SELECT * FROM motor_equipment 
WHERE is_available = TRUE 
AND type = 'мотоцикл' 
AND brand = 'Honda' 
AND engine_volume >= 500;

SELECT name, phone, insurance_company, insurance_expiry 
FROM clients 
WHERE insurance_expiry < CURRENT_DATE;

SELECT m.brand, m.model, COUNT(*) AS rental_count 
FROM motor_equipment m
JOIN rental_items ri ON ri.item_id = m.id AND ri.item_type = 'motor'
GROUP BY m.brand, m.model 
ORDER BY rental_count DESC 
LIMIT 5;

SELECT r.id, c.name, r.start_date, r.end_date 
FROM rentals r
JOIN clients c ON r.client_id = c.id 
WHERE r.status = 'active';

SELECT AVG(end_date - start_date) AS avg_rental_days 
FROM rentals;

SELECT c.name, SUM(r.total_price) AS total_spent 
FROM clients c
JOIN rentals r ON c.id = r.client_id 
GROUP BY c.name 
ORDER BY total_spent DESC 
LIMIT 10;

SELECT * FROM gear 
WHERE is_available = TRUE 
AND type = 'шлем' 
AND size = 'L';

SELECT r.id, c.name, m.brand, m.model, r.end_date 
FROM rentals r
JOIN clients c ON r.client_id = c.id
JOIN rental_items ri ON ri.rental_id = r.id AND ri.item_type = 'motor'
JOIN motor_equipment m ON m.id = ri.item_id 
WHERE r.status = 'active' 
AND r.end_date BETWEEN CURRENT_DATE AND CURRENT_DATE + 3;