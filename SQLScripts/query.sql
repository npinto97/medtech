-- Operation 1: Register a new product batchINSERT INTO Batch_TABLE

SELECT 
  'BATCH123',
  100,
  TO_DATE('2025-06-12', 'YYYY-MM-DD'),
  (SELECT REF(p) FROM Product p WHERE p.serialNumber = 'SN1700'),       -- productRef
  (SELECT REF(dc) FROM DistributionCenter dc WHERE dc.centerName = 'DC666')  -- distributionCenterRef
FROM DUAL;

-- Operation 2: Place a new order

UPDATE Customer c
SET c.orders = c.orders MULTISET UNION Order_NT(
  Order_TY(
    'ORD0564',
    TO_DATE('2025-06-12', 'YYYY-MM-DD'),
    TO_DATE('2025-06-15', 'YYYY-MM-DD'),
    'in_progress',
    Batch_REF_NT(
      (SELECT REF(b) FROM Batch_TABLE b WHERE b.batchID = 'B004'),
      (SELECT REF(b) FROM Batch_TABLE b WHERE b.batchID = 'B005')
    ), 
    NULL   -- managedBy (verrà assegnato dopo)
  )
)
WHERE c.code = 'CU09';

-- Operation 3: Assign a delivery to a logistics team

UPDATE TABLE (
  SELECT c.orders FROM Customer c WHERE c.code = 'CU09'
) o
SET o.managedBy = (SELECT REF(t) FROM LogisticsTeam t WHERE t.code = 'LT02')
WHERE o.orderID = 'ORD0564';

select * from table(dbms_xplan.display_cursor(sql_id=>'g7jtjxbsu4s1d', format=>'ALLSTATS LAST'));


-- Operation 4: View all deliveries assigned to the team coordinated by a specific chief officer

SELECT c.code AS customerCode, o.orderID, o.status, o.expectedDeliveryDate
FROM Customer c,
     TABLE(c.orders) o,
     LogisticsTeam t
WHERE t.chief.taxCode = 'CL666'
  AND o.managedBy = REF(t);

-- Operation 5: List all batches of expired products

SELECT b.batchID, b.quantity, b.arrivalDate, p.productName, p.expiryDate
FROM Batch_TABLE b, Product p
WHERE b.productRef = REF(p)
  AND p.expiryDate IS NOT NULL
  AND p.expiryDate < SYSDATE;

-- Inserisco un prodotto scaduto
INSERT INTO Product
VALUES (
  Product_TY(
    'P999',
    'Garze sterili',
    'disposable',
    TO_DATE('2023/12/31', 'YYYY/MM/DD')
  )
);

-- Verifica della scadenza tramite member function
SET SERVEROUTPUT ON;

DECLARE
  prod_obj Product_TY;  -- variabile per l'oggetto prodotto
  scaduto BOOLEAN;
BEGIN
  -- Recupera l'oggetto prodotto con serialNumber = 'P999'
  SELECT VALUE(p)
  INTO prod_obj
  FROM Product p
  WHERE p.serialNumber = 'P999';

  -- Chiama la funzione membro is_expired per verificare se è scaduto
  scaduto := prod_obj.is_expired;

  IF scaduto THEN
    DBMS_OUTPUT.PUT_LINE('Il prodotto ' || prod_obj.productName || ' è scaduto.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Il prodotto ' || prod_obj.productName || ' non è scaduto.');
  END IF;
END;
/

-- Test del trigger per i batch di prodotti scaduti
DECLARE
  p_ref REF Product_TY;
  c_ref REF DistributionCenter_TY;
BEGIN
  SELECT REF(p)
  INTO p_ref
  FROM Product p
  WHERE p.serialNumber = 'P999';

  SELECT REF(c)
  INTO c_ref
  FROM DistributionCenter c
  WHERE c.centername = 'DC04';

  INSERT INTO Batch_TABLE
  VALUES (
    Batch_TY(
      'B123',
      50,
      TO_DATE('2025/06/10', 'YYYY/MM/DD'),
      p_ref,
      c_ref
    )
  );
END;
/

-- F10 per il query plan
-- Analisi dell'indice idx_product_expiry
SELECT serialNumber, productName, expiryDate
FROM Product
WHERE expiryDate < SYSDATE;

-- Analisi dell'indice idx_batch_arrival 
SELECT batchID, arrivalDate
FROM Batch_TABLE
WHERE arrivalDate > SYSDATE - 30;

-- Analisi dell'indice idx_batch_quantity 
SELECT batchID, quantity
FROM Batch_TABLE
WHERE quantity < 10;

-- Analisi dell'indice idx_customer_type 
SELECT code, customerName
FROM Customer
WHERE customerType = 'Ospedale';

