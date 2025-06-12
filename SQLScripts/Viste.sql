-- Permette di visualizzare i batch diprodotti scaduti
CREATE OR REPLACE VIEW Expired_Batches_VW AS
SELECT b.batchID,
       b.quantity,
       b.arrivalDate,
       p.productName,
       p.expiryDate
FROM Batch_TABLE b
JOIN Product p ON b.productRef = REF(p)
WHERE p.expiryDate IS NOT NULL
  AND p.expiryDate < SYSDATE;

-- Permette di accedere agli ordini dei clienti senza usare TABLE() ogni volta
CREATE OR REPLACE VIEW Customer_Orders_VW AS
SELECT c.code AS customerCode,
       o.orderID,
       o.status,
       o.orderDate,
       o.expectedDeliveryDate
FROM Customer c,
     TABLE(c.orders) o;

-- Rende permanente la funzione get_team_deliveries
CREATE OR REPLACE VIEW Team_Deliveries_VW AS
SELECT c.code AS customerCode,
       o.orderID,
       o.status,
       o.expectedDeliveryDate,
       lt.code AS teamCode,
       lt.chief.taxCode AS chiefTaxCode
FROM Customer c,
     TABLE(c.orders) o,
     LogisticsTeam lt
WHERE o.managedBy = REF(lt);

-- Per vedere tutti i reclami clienti in formato flat
CREATE OR REPLACE VIEW All_Complaints_VW AS
SELECT c.code AS customerCode,
       comp.complaintID,
       comp.compliantDate,
       comp.reason,
       comp.complaintDescription
FROM Customer c,
     TABLE(c.complaints) comp;
