-- DROP IF THE FOLLOWING TABLES EXIST --
-- STEP 1: DROP TABLES (dipendenti dai tipi)
DROP TABLE Customer CASCADE CONSTRAINTS PURGE;
DROP TABLE LogisticsTeam CASCADE CONSTRAINTS PURGE;
DROP TABLE DistributionCenter CASCADE CONSTRAINTS PURGE;
DROP TABLE ChiefLogisticsOfficer CASCADE CONSTRAINTS PURGE;
DROP TABLE Product CASCADE CONSTRAINTS PURGE;
DROP TABLE Batch_TABLE CASCADE CONSTRAINTS PURGE;

-- STEP 2: DROP TYPES IN ORDER (dall’esterno all’interno)
-- Nested Tables
DROP TYPE Complaint_NT FORCE;
DROP TYPE Order_NT FORCE;
DROP TYPE TeamMember_NT FORCE;
DROP TYPE Department_NT FORCE;
DROP TYPE Batch_NT FORCE;
DROP TYPE Batch_REF_NT FORCE;


-- Element Types
DROP TYPE Complaint_TY FORCE;
DROP TYPE Order_TY FORCE;
DROP TYPE LogisticsTeam_TY FORCE;
DROP TYPE ChiefLogisticsOfficer_TY FORCE;
DROP TYPE TeamMember_TY FORCE;
DROP TYPE LogisticsEmployee_TY FORCE;
DROP TYPE DistributionCenter_TY FORCE;
DROP TYPE Department_TY FORCE;
DROP TYPE Batch_TY FORCE;
DROP TYPE Product_TY FORCE;
DROP TYPE Customer_TY FORCE;
/

-- Product
CREATE OR REPLACE TYPE Product_TY AS OBJECT (
  serialNumber          VARCHAR2(50),
  productName           VARCHAR2(100),
  productCategory       VARCHAR2(50),
  expiryDate            DATE,
  
  MEMBER FUNCTION is_expired RETURN BOOLEAN
);
/
CREATE OR REPLACE TYPE BODY Product_TY AS 
  MEMBER FUNCTION is_expired RETURN BOOLEAN IS
  BEGIN
    RETURN expiryDate IS NOT NULL AND expiryDate < SYSDATE;
  END;
END;
/
-- Department
CREATE OR REPLACE TYPE Department_TY AS OBJECT (
  departmentID       VARCHAR2(50),
  departmentName     VARCHAR2(100),
  contactInfo        VARCHAR2(150),
  supplyPreferences  VARCHAR2(200)
);
/
-- Collezione di Department
CREATE OR REPLACE TYPE Department_NT AS TABLE OF Department_TY;
/
-- LogisticsEmployee (abstract base)
CREATE OR REPLACE TYPE LogisticsEmployee_TY AS OBJECT (
  taxCode        VARCHAR2(20),
  employeeName   VARCHAR2(50),
  surname        VARCHAR2(50),
  birthDate      DATE,
  employmentDate DATE
) 
NOT INSTANTIABLE
NOT FINAL;
/
-- ChiefLogisticsOfficer (specializzazione)
CREATE OR REPLACE TYPE ChiefLogisticsOfficer_TY UNDER LogisticsEmployee_TY (
  yearsOfExperience NUMBER
);
/
-- TeamMember (specializzazione)
CREATE OR REPLACE TYPE TeamMember_TY UNDER LogisticsEmployee_TY (
);
/
-- Collezione TeamMember
CREATE OR REPLACE TYPE TeamMember_NT AS TABLE OF TeamMember_TY;
/
-- DistributionCenter
CREATE OR REPLACE TYPE DistributionCenter_TY AS OBJECT (
  centerName        VARCHAR2(100),
  centerLocation    VARCHAR2(150)
);
/
-- Batch
CREATE OR REPLACE TYPE Batch_TY AS OBJECT (
  batchID               VARCHAR2(50),
  quantity              NUMBER,
  arrivalDate           DATE,
  productRef            REF Product_TY,
  distributionCenterRef REF DistributionCenter_TY,

  MEMBER FUNCTION is_valid RETURN BOOLEAN,
  MEMBER FUNCTION is_product_expired RETURN BOOLEAN
);
/
CREATE OR REPLACE TYPE BODY Batch_TY AS 
  MEMBER FUNCTION is_valid RETURN BOOLEAN IS
  BEGIN
    RETURN quantity > 0;
  END;

  MEMBER FUNCTION is_product_expired RETURN BOOLEAN IS
    p Product_TY;
  BEGIN
    IF productRef IS NULL THEN
      RETURN FALSE;
    END IF;

    SELECT DEREF(productRef) INTO p FROM DUAL;
    RETURN p.expiryDate IS NOT NULL AND p.expiryDate < SYSDATE;
  END;
END;
/

-- Tipo REF su Batch_TY
CREATE OR REPLACE TYPE Batch_REF_TY AS OBJECT (
  dummy VARCHAR2(1)  -- serve solo per aggirare la limitazione JDBC, verrà ignorato
);

-- Nested table di REF
CREATE OR REPLACE TYPE Batch_REF_NT AS TABLE OF REF Batch_TY;

-- Collezione di Batch
CREATE OR REPLACE TYPE Batch_NT AS TABLE OF Batch_TY;
/
CREATE OR REPLACE TYPE Batch_REF_NT AS TABLE OF REF Batch_TY;
/
-- LogisticsTeam
CREATE OR REPLACE TYPE LogisticsTeam_TY AS OBJECT (
  code          VARCHAR2(20),
  teamName      VARCHAR2(100),
  chief         REF ChiefLogisticsOfficer_TY,
  members       TeamMember_NT,
  centerRef     REF DistributionCenter_TY
);
/
-- Order
CREATE OR REPLACE TYPE Order_TY AS OBJECT (
  orderID               VARCHAR2(50),
  orderDate             DATE,
  expectedDeliveryDate  DATE,
  status                VARCHAR2(20),
  batches               Batch_REF_NT,
  managedBy             REF LogisticsTeam_TY,
  
  MEMBER FUNCTION is_valid RETURN BOOLEAN
);
/
CREATE OR REPLACE TYPE BODY Order_TY AS 
  MEMBER FUNCTION is_valid RETURN BOOLEAN IS
  BEGIN
    RETURN status IN ('in_progress', 'shipped', 'delivered', 'cancelled')
           AND orderDate <= expectedDeliveryDate;
  END;
END;
/
-- Collezione di Order
CREATE OR REPLACE TYPE Order_NT AS TABLE OF Order_TY;
/
-- Complaint
CREATE OR REPLACE TYPE Complaint_TY AS OBJECT (
  complaintID           VARCHAR2(50),
  compliantDate         DATE,
  reason                VARCHAR2(20),
  complaintDescription  VARCHAR2(200),
  
  MEMBER FUNCTION is_valid RETURN BOOLEAN
);
/
CREATE OR REPLACE TYPE BODY Complaint_TY AS 
  MEMBER FUNCTION is_valid RETURN BOOLEAN IS
  BEGIN
    RETURN reason IN ('delivery', 'product', 'billing', 'other');
  END;
END;
/
-- Collezione di Complaint
CREATE OR REPLACE TYPE Complaint_NT AS TABLE OF Complaint_TY;
/
CREATE OR REPLACE TYPE Customer_TY AS OBJECT (
  code         VARCHAR2(20),
  customerName VARCHAR2(100),
  customerType VARCHAR2(20),
  departments  Department_NT,
  orders       Order_NT,
  complaints   Complaint_NT,
  
  MEMBER FUNCTION all_orders_valid RETURN BOOLEAN,
  MEMBER FUNCTION all_complaints_valid RETURN BOOLEAN
);
/
CREATE OR REPLACE TYPE BODY Customer_TY AS 
  MEMBER FUNCTION all_orders_valid RETURN BOOLEAN IS
  BEGIN
    IF orders IS NOT NULL THEN
      FOR i IN 1 .. orders.COUNT LOOP
        IF NOT orders(i).is_valid THEN
          RETURN FALSE;
        END IF;
      END LOOP;
    END IF;
    RETURN TRUE;
  END;
  
  MEMBER FUNCTION all_complaints_valid RETURN BOOLEAN IS
  BEGIN
    IF complaints IS NOT NULL THEN
      FOR i IN 1 .. complaints.COUNT LOOP
        IF NOT complaints(i).is_valid THEN
          RETURN FALSE;
        END IF;
      END LOOP;
    END IF;
    RETURN TRUE;
  END;
END;
/
-- Tabella dei prodotti
CREATE TABLE Product OF Product_TY (
  serialNumber PRIMARY KEY,
  productName NOT NULL,
  productCategory NOT NULL
);
--Taaabella dei batch
CREATE TABLE Batch_TABLE OF Batch_TY (
  batchID PRIMARY KEY,
  quantity NOT NULL,
  arrivalDate NOT NULL
);

-- Tabella dei clienti
CREATE TABLE Customer OF Customer_TY (
  code PRIMARY KEY,
  customerName NOT NULL,
  customerType CHECK (customerType IN ('hospital', 'clinic'))
)
NESTED TABLE departments STORE AS departments_nt
NESTED TABLE orders STORE AS orders_nt
  (NESTED TABLE batches STORE AS customer_order_batches_nt)
NESTED TABLE complaints STORE AS complaints_nt;
/
-- Tabella dei centri di distribuzione
CREATE TABLE DistributionCenter OF DistributionCenter_TY (
  centerName PRIMARY KEY,
  centerLocation NOT NULL
);
/
-- Tabella dei team logistici
CREATE TABLE LogisticsTeam OF LogisticsTeam_TY (
  code PRIMARY KEY,
  teamName NOT NULL
)
NESTED TABLE members STORE AS members_nt;
/
-- Tabella dei ChiefLogisticsOfficer
CREATE TABLE ChiefLogisticsOfficer OF ChiefLogisticsOfficer_TY (
  taxCode PRIMARY KEY,
  CONSTRAINT chk_yearsOfExperience CHECK (yearsOfExperience >= 0)
);
/

-- CCcreazione indici
-- utile per operazione 1 (registrazione batch), per ordinare o filtrare batch recenti
CREATE INDEX idx_batch_arrival ON Batch_TABLE(arrivalDate);
-- supporta la funzione is_valid e potrebbe essere utile per trovare batch critici con bassa disponibilità
CREATE INDEX idx_batch_quantity ON Batch_TABLE(quantity);
-- operazione 5: "List all batches of expired products". Per verificare se un prodotto è scaduto, si interroga Product.expiryDate.
CREATE INDEX idx_product_expiry ON Product(expiryDate);
-- permette ricerche filtrate per tipo di cliente (ospedale, clinica)
CREATE INDEX idx_customer_type ON Customer(customerType);

-- Creeeazioni di funzioni e procedddure (corrispondenti alle operazioni)
-- Operation 1: Register a new product batch (100 times per day).
CREATE OR REPLACE PROCEDURE register_new_batch (
  p_batchID       IN VARCHAR2,
  p_quantity      IN NUMBER,
  p_arrivalDate   IN DATE,
  p_productSN     IN VARCHAR2,
  p_centerName    IN VARCHAR2
) IS
  v_product_ref  REF Product_TY;
  v_center_ref   REF DistributionCenter_TY;
BEGIN
  SELECT REF(p) INTO v_product_ref FROM Product p WHERE p.serialNumber = p_productSN;
  SELECT REF(dc) INTO v_center_ref FROM DistributionCenter dc WHERE dc.centerName = p_centerName;
  
  INSERT INTO Batch_TABLE VALUES (
    Batch_TY(p_batchID, p_quantity, p_arrivalDate, v_product_ref, v_center_ref)
  );
END;
/
-- Operation 2: Place a new order (70 times per day).
CREATE OR REPLACE PROCEDURE place_order (
  p_customerCode         IN VARCHAR2,
  p_orderID              IN VARCHAR2,
  p_orderDate            IN DATE,
  p_expectedDeliveryDate IN DATE,
  p_status               IN VARCHAR2,
  p_batchIDs_string      IN VARCHAR2
) IS
  v_batchIDs     DBMS_SQL.VARCHAR2_TABLE;
  v_batchRefList Batch_REF_NT := Batch_REF_NT();
  v_order        Order_TY;

  -- Funzione locale per split della stringa su virgola
  FUNCTION split_string(p_str VARCHAR2) RETURN DBMS_SQL.VARCHAR2_TABLE IS
    v_res DBMS_SQL.VARCHAR2_TABLE;
    v_idx PLS_INTEGER := 1;
    v_pos PLS_INTEGER := 0;
    v_temp VARCHAR2(1000);
    v_count PLS_INTEGER := 0;
  BEGIN
    LOOP
      v_pos := INSTR(p_str, ',', v_idx);
      IF v_pos = 0 THEN
        v_temp := TRIM(SUBSTR(p_str, v_idx));
        EXIT WHEN v_temp IS NULL;
        v_count := v_count + 1;
        v_res(v_count) := v_temp;
        EXIT;
      ELSE
        v_temp := TRIM(SUBSTR(p_str, v_idx, v_pos - v_idx));
        v_count := v_count + 1;
        v_res(v_count) := v_temp;
        v_idx := v_pos + 1;
      END IF;
    END LOOP;
    RETURN v_res;
  END;

BEGIN
  v_batchIDs := split_string(p_batchIDs_string);

  FOR i IN 1 .. v_batchIDs.COUNT LOOP
    DECLARE
      v_ref REF Batch_TY;
    BEGIN
      SELECT REF(b) INTO v_ref FROM Batch_TABLE b WHERE b.batchID = v_batchIDs(i);
      v_batchRefList.EXTEND;
      v_batchRefList(v_batchRefList.COUNT) := v_ref;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL; -- Puoi loggare o gestire l'errore
    END;
  END LOOP;

  v_order := Order_TY(p_orderID, p_orderDate, p_expectedDeliveryDate, p_status, v_batchRefList, NULL);

  UPDATE Customer c
  SET c.orders = c.orders MULTISET UNION Order_NT(v_order)
  WHERE c.code = p_customerCode;
END;
/

-- Operation 3: Assign a delivery to a logistics team (40 times per day).
CREATE OR REPLACE PROCEDURE assign_delivery (
  p_customerCode IN VARCHAR2,
  p_orderID      IN VARCHAR2,
  p_teamCode     IN VARCHAR2
) IS
  v_team_ref REF LogisticsTeam_TY;
BEGIN
  SELECT REF(t) INTO v_team_ref FROM LogisticsTeam t WHERE t.code = p_teamCode;
  
  UPDATE TABLE(
    SELECT c.orders FROM Customer c WHERE c.code = p_customerCode
  ) o
  SET o.managedBy = v_team_ref
  WHERE o.orderID = p_orderID;
END;
/

-- Operation 4: View all deliveries assigned to the team coordinated by a specific chief officer (1 per week).
CREATE OR REPLACE FUNCTION get_team_deliveries (
  p_chiefTaxCode IN VARCHAR2
) RETURN SYS_REFCURSOR IS
  v_cursor SYS_REFCURSOR;
BEGIN
  OPEN v_cursor FOR
    SELECT c.code AS customerCode, o.orderID, o.status, o.expectedDeliveryDate
    FROM Customer c,
         TABLE(c.orders) o,
         LogisticsTeam lt
    WHERE lt.chief.taxCode = p_chiefTaxCode
      AND o.managedBy = REF(lt);
  RETURN v_cursor;
END;
/
-- Operation 5: List all batches of expired products (20 times per day).
CREATE OR REPLACE FUNCTION get_expired_batches
RETURN SYS_REFCURSOR IS
  v_cursor SYS_REFCURSOR;
BEGIN
  OPEN v_cursor FOR
    SELECT b.batchID, b.quantity, b.arrivalDate, p.productName, p.expiryDate
    FROM Batch_TABLE b,
         Product p
    WHERE b.productRef = REF(p)
      AND p.expiryDate IS NOT NULL
      AND p.expiryDate < SYSDATE;
  RETURN v_cursor;
END;
/


-- Creazione trigger

-- Trigger sulla tabella Batch_TABLE
--  Validazione automatica di un nuovo batch
CREATE OR REPLACE TRIGGER trg_validate_batch
BEFORE INSERT OR UPDATE ON Batch_TABLE
FOR EACH ROW
DECLARE
  v_batch Batch_TY;
BEGIN
  -- Istanziazione manuale per   poter utilizzare la member fuunction isValid
  v_batch := Batch_TY(
    :NEW.batchID,
    :NEW.quantity,
    :NEW.arrivalDate,
    :NEW.productRef,
    :NEW.distributionCenterRef
  );

  IF NOT v_batch.is_valid THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid batch: quantity must be greater than 0.');
  END IF;
END;
/
-- Blocco dell'inserimento di batch con prodotti scaduti
CREATE OR REPLACE TRIGGER trg_prevent_expired_batch
BEFORE INSERT OR UPDATE ON Batch_TABLE
FOR EACH ROW
DECLARE
  v_batch Batch_TY;
BEGIN
  -- Costruzione esplicita dell'oggetto Batch_TY
  v_batch := Batch_TY(
    :NEW.batchID,
    :NEW.quantity,
    :NEW.arrivalDate,
    :NEW.productRef,
    :NEW.distributionCenterRef
  );
  
  -- Chiamata alla funzione membro
  IF v_batch.is_product_expired THEN
    RAISE_APPLICATION_ERROR(-20002, 'Error: the product associated with the batch is expired.');
  END IF;
END;
/
-- Trigger sulla tabella Customer
-- Validazione di tutti gli ordini di un  cliente

CREATE OR REPLACE TRIGGER trg_check_customer_orders
BEFORE INSERT OR UPDATE ON Customer
FOR EACH ROW
DECLARE
  v_customer Customer_TY;
BEGIN
  v_customer := Customer_TY(
    :NEW.code,
    :NEW.customerName,
    :NEW.customerType,
    :NEW.departments,
    :NEW.orders,
    :NEW.complaints
  );

  IF NOT v_customer.all_orders_valid THEN
    RAISE_APPLICATION_ERROR(-20003, 'Error: one or more customer order are not valid.');
  END IF;
END;
/

-- Validazione dei reclami
CREATE OR REPLACE TRIGGER trg_check_customer_complaints
BEFORE INSERT OR UPDATE ON Customer
FOR EACH ROW
DECLARE
  v_customer Customer_TY;
BEGIN
  v_customer := Customer_TY(
    :NEW.code,
    :NEW.customerName,
    :NEW.customerType,
    :NEW.departments,
    :NEW.orders,
    :NEW.complaints
  );

  IF NOT v_customer.all_complaints_valid THEN
    RAISE_APPLICATION_ERROR(-20004, 'Error: one or more customer complaint are not valid.');
  END IF;
END;
/

-- Trigger sulla tabella Product
CREATE OR REPLACE TRIGGER trg_block_expiry_update
BEFORE UPDATE OF expiryDate ON Product
FOR EACH ROW
DECLARE
  v_product_ref REF Product_TY;
  v_exists NUMBER;
BEGIN
  -- REF al vecchio prodotto
  SELECT REF(p)
  INTO v_product_ref
  FROM Product p
  WHERE p.serialNumber = :OLD.serialNumber;
  
  -- Controlliamo se ci sono batch con quell'oggetto già arrivati
  SELECT COUNT(*)
  INTO v_exists
  FROM Batch_TABLE b
  WHERE b.productRef = v_product_ref
    AND b.arrivalDate < SYSDATE;

  -- Se esistono e stai mettendo una scadenza nel passato, blocca
  IF v_exists > 0 AND :NEW.expiryDate < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20005, 'Cannot set expiry date to past for already delivered product.');
  END IF;
END;
/

-- Trigger sulla tabella LogisticsTeam
-- Validazione che il chief esista e sia coerente
CREATE OR REPLACE TRIGGER trg_validate_chief
BEFORE INSERT OR UPDATE ON LogisticsTeam
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM ChiefLogisticsOfficer c
  WHERE REF(c) = :NEW.chief;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20006, 'ChiefLogisticsOfficer reference is invalid.');
  END IF;
END;
/
-- Trigger sulla tabella ChiefLogisticsOfficer
-- Evita la cancellazione di un chief associato a un team
CREATE OR REPLACE TRIGGER trg_protect_chief_deletion
BEFORE DELETE ON ChiefLogisticsOfficer
FOR EACH ROW
DECLARE
  v_chief_ref REF ChiefLogisticsOfficer_TY;
  v_count NUMBER;
BEGIN
  -- riferimento alChiefLogisticsOfficer da cancellare
  SELECT REF(c)
  INTO v_chief_ref
  FROM ChiefLogisticsOfficer c
  WHERE c.taxCode = :OLD.taxCode;
  
  -- Verifica se qualche LogisticsTeam lo usa come chief
  SELECT COUNT(*) INTO v_count
  FROM LogisticsTeam t
  WHERE t.chief = v_chief_ref;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Cannot delete ChiefLogisticsOfficer referenced by a team.');
  END IF;
END;
/

--Popolamento database
-- Inserimento Prodotti
INSERT INTO Product VALUES (
  Product_TY('SN1666', 'Siringa sterile', 'medical', DATE '2026-12-01')
);
INSERT INTO Product VALUES (
  Product_TY('SN1667', 'Bisturi', 'surgical', DATE '2025-08-20')
);
INSERT INTO Product VALUES (
  Product_TY('SN1668', 'Guanti in lattice', 'disposable', DATE '2024-12-01')
);
INSERT INTO Product VALUES (
  Product_TY('SN1669', 'Mascherina FFP2', 'disposable', NULL)
);
INSERT INTO Product VALUES (
  Product_TY('SN1700', 'Soluzione fisiologica', 'pharmaceutical', DATE '2025-10-15')
);
INSERT INTO Product VALUES (
  Product_TY('SN1006', 'Antibiotico A', 'Farmaco', ADD_MONTHS(SYSDATE, 12))
);
/
--Inseeerimento Centri di Distribuzione
INSERT INTO DistributionCenter VALUES (
  DistributionCenter_TY('DC666', 'Milano, Via della Salute 10')
);
INSERT INTO DistributionCenter VALUES (
  DistributionCenter_TY('DC667', 'Roma, Viale dei Medici 22')
);
INSERT INTO DistributionCenter VALUES (
  DistributionCenter_TY('DC668', 'Torino, Corso Sanità 15')
);
-- Inserimeento CLO
INSERT INTO ChiefLogisticsOfficer VALUES (
  ChiefLogisticsOfficer_TY('CL666', 'Mario', 'Rossi', DATE '1980-05-10', DATE '2010-06-01', 15)
);
INSERT INTO ChiefLogisticsOfficer VALUES (
  ChiefLogisticsOfficer_TY('CL667', 'Luisa', 'Verdi', DATE '1975-07-22', DATE '2005-03-12', 20)
);
INSERT INTO DistributionCenter VALUES (
  DistributionCenter_TY('CentroNord', 'Via Milano 10, Milano')
);
/
-- Inserimento Team
DECLARE
  chief1 REF ChiefLogisticsOfficer_TY;
  chief2 REF ChiefLogisticsOfficer_TY;
  center1 REF DistributionCenter_TY;
BEGIN
  SELECT REF(c) INTO chief1 FROM ChiefLogisticsOfficer c WHERE c.taxCode = 'CL666';
  SELECT REF(c) INTO chief2 FROM ChiefLogisticsOfficer c WHERE c.taxCode = 'CL667';
  SELECT REF(dc) INTO center1 FROM DistributionCenter dc WHERE dc.centerName = 'DC666';
  
  INSERT INTO LogisticsTeam VALUES (
    LogisticsTeam_TY(
      'LT666',
      'Team Nord',
      chief1,
      TeamMember_NT(
        TeamMember_TY('TM666', 'Laura', 'Bianchi', DATE '1990-02-11', DATE '2015-09-01'),
        TeamMember_TY('TM667', 'Gianni', 'Moretti', DATE '1992-08-03', DATE '2016-07-15')
      ),
      center1
    )
  );
END;
/
-- Inserimento batch
DECLARE
  prod1 REF Product_TY;
  prod2 REF Product_TY;
  dc1 REF DistributionCenter_TY;
BEGIN
  SELECT REF(p) INTO prod1 FROM Product p WHERE p.serialNumber = 'SN1666';
  SELECT REF(p) INTO prod2 FROM Product p WHERE p.serialNumber = 'SN1667';
  SELECT REF(dc) INTO dc1 FROM DistributionCenter dc WHERE dc.centerName = 'DC666';
  
  INSERT INTO Batch_TABLE VALUES (
    Batch_TY('B666', 500, SYSDATE - 10, prod1, dc1)
  );

  INSERT INTO Batch_TABLE VALUES (
    Batch_TY('B667', 250, SYSDATE - 30, prod2, dc1)
  );
END;
/
-- Inserimento clienti
DECLARE
  team1 REF LogisticsTeam_TY;
  batch1 REF Batch_TY;
  batch2 REF Batch_TY;
BEGIN
  SELECT REF(l) INTO team1 FROM LogisticsTeam l WHERE l.code = 'LT666';
  SELECT REF(b) INTO batch1 FROM Batch_TABLE b WHERE b.batchID = 'B666';
  SELECT REF(b) INTO batch2 FROM Batch_TABLE b WHERE b.batchID = 'B667';
  
  INSERT INTO Customer VALUES (
    Customer_TY(
      'C666',
      'Ospedale San Marco',
      'hospital',
      Department_NT(
        Department_TY('D666', 'Cardiologia', 'cardio@sanmarco.it', 'Sterile equipment'),
        Department_TY('D667', 'Chirurgia', 'surgery@sanmarco.it', 'Surgical tools')
      ),
      Order_NT(
        Order_TY('6666', SYSDATE - 5, SYSDATE + 3, 'in_progress', Batch_REF_NT(batch1, batch2), team1)
      ),
      Complaint_NT(
        Complaint_TY('CMP666', SYSDATE - 2, 'delivery', 'Consegna in ritardo di 1 giorno')
      )
    )
  );
END;
/
-- Procedura per il popolamento automatico
DECLARE
  v_prod REF Product_TY;
  v_dc REF DistributionCenter_TY;
  v_chief REF ChiefLogisticsOfficer_TY;
  v_team REF LogisticsTeam_TY;
  v_batch REF Batch_TY;
  v_team_members TeamMember_NT := TeamMember_NT();
  v_departments Department_NT := Department_NT();
  v_orders Order_NT := Order_NT();
  v_complaints Complaint_NT := Complaint_NT();
  i NUMBER;
BEGIN
-- Inserimento Prodotti
  FOR i IN 1 .. 20 LOOP
    INSERT INTO Product VALUES (
      Product_TY(
        'P' || TO_CHAR(i, 'FM000'),
        'Prodotto_' || i,
        CASE MOD(i, 4)
          WHEN 0 THEN 'medical'
          WHEN 1 THEN 'surgical'
          WHEN 2 THEN 'disposable'
          ELSE 'pharmaceutical'
        END,
        SYSDATE + (30 * (MOD(i, 5) + 1))  -- almeno +30 giorni
      )
    );
  END LOOP;
  -- Inserimento DistributionCenter
  FOR i IN 1 .. 10 LOOP
    INSERT INTO DistributionCenter VALUES (
      DistributionCenter_TY(
        'DC' || TO_CHAR(i, 'FM00'),
        'Città ' || i || ', Via Distribuzione ' || i
      )
    );
  END LOOP;
  -- ChiefLogisticsOfficer
  FOR i IN 1 .. 5 LOOP
    INSERT INTO ChiefLogisticsOfficer VALUES (
      ChiefLogisticsOfficer_TY(
        'CLO' || TO_CHAR(i, 'FM00'),
        'ChiefName_' || i,
        'ChiefSurname_' || i,
        DATE '1980-01-01' + i * 200,
        SYSDATE - (i * 1000),
        5 + i
      )
    );
  END LOOP;
  -- LogisticsTeam
  FOR i IN 1 .. 5 LOOP
    SELECT REF(c) INTO v_chief FROM ChiefLogisticsOfficer c WHERE c.taxCode = 'CLO' || TO_CHAR(i, 'FM00');
    SELECT REF(d) INTO v_dc FROM DistributionCenter d WHERE d.centerName = 'DC' || TO_CHAR(i, 'FM00');
    
    v_team_members := TeamMember_NT();
    FOR j IN 1 .. 4 LOOP
      v_team_members.EXTEND;
      v_team_members(v_team_members.LAST) := TeamMember_TY(
        'TM' || TO_CHAR((i - 1) * 4 + j, 'FM000'),
        'MemberName_' || ((i - 1) * 4 + j),
        'MemberSurname_' || ((i - 1) * 4 + j),
        DATE '1990-01-01' + ((i - 1) * 4 + j) * 50,
        SYSDATE - ((i - 1) * 4 + j) * 100
      );
    END LOOP;
    
    INSERT INTO LogisticsTeam VALUES (
      LogisticsTeam_TY(
        'LT' || TO_CHAR(i, 'FM00'),
        'Team_' || i,
        v_chief,
        v_team_members,
        v_dc
      )
    );
  END LOOP;
  
  -- Batch
  FOR i IN 1 .. 50 LOOP
    SELECT REF(p) INTO v_prod FROM Product p WHERE p.serialNumber = 'P' || TO_CHAR(MOD(i, 20) + 1, 'FM000');
    SELECT REF(d) INTO v_dc FROM DistributionCenter d WHERE d.centerName = 'DC' || TO_CHAR(MOD(i, 10) + 1, 'FM00');

    INSERT INTO Batch_TABLE VALUES (
      Batch_TY(
        'B' || TO_CHAR(i, 'FM000'),
        100 + MOD(i, 400),
        SYSDATE - MOD(i, 20),
        v_prod,
        v_dc
      )
    );
  END LOOP;
  
  -- Customer con reparti, ordini e reclami
  FOR i IN 1 .. 10 LOOP
    v_departments := Department_NT();
    v_departments.EXTEND(2);
    v_departments(1) := Department_TY('D' || i || 'A', 'Dip_A_' || i, 'a_dep@cliente' || i || '.it', 'Surgical tools');
    v_departments(2) := Department_TY('D' || i || 'B', 'Dip_B_' || i, 'b_dep@cliente' || i || '.it', 'Pharmaceuticals');

    v_orders := Order_NT();
    FOR j IN 1 .. 2 LOOP
      SELECT REF(b) INTO v_batch FROM Batch_TABLE b WHERE b.batchID = 'B' || TO_CHAR(MOD((i-1)*5 + j, 50) + 1, 'FM000');
      SELECT REF(l) INTO v_team FROM LogisticsTeam l WHERE l.code = 'LT' || TO_CHAR(MOD(i, 5) + 1, 'FM00');

      v_orders.EXTEND;
      v_orders(v_orders.LAST) := Order_TY(
        'O' || i || j,
        SYSDATE - (j * 5),
        SYSDATE + (j * 2),
        CASE j WHEN 1 THEN 'in_progress' ELSE 'shipped' END,
        Batch_REF_NT(v_batch),
        v_team
      );
    END LOOP;
    
    v_complaints := Complaint_NT();
    v_complaints.EXTEND;
    v_complaints(1) := Complaint_TY(
      'CMP' || i,
      SYSDATE - i,
      CASE MOD(i, 4)
        WHEN 0 THEN 'delivery'
        WHEN 1 THEN 'product'
        WHEN 2 THEN 'billing'
        ELSE 'other'
      END,
      'Descrizione del reclamo del cliente ' || i
    );
    
    INSERT INTO Customer VALUES (
      Customer_TY(
        'CU' || TO_CHAR(i, 'FM00'),
        'Cliente_' || i,
        CASE MOD(i, 2) WHEN 0 THEN 'hospital' ELSE 'clinic' END,
        v_departments,
        v_orders,
        v_complaints
      )
    );
  END LOOP;
END;
/

