CREATE TABLE bk_467575_2025.clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    insurance_company VARCHAR(100),
    insurance_amount DECIMAL(10, 2),
    insurance_expiry DATE
);

CREATE TABLE bk_467575_2025.motor_equipment (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    engine_volume DECIMAL(5, 1) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('мотоцикл', 'скутер', 'квадроцикл')),
    daily_price DECIMAL(10, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE bk_467575_2025.gear (
    id SERIAL PRIMARY KEY,
    type VARCHAR(20) NOT NULL CHECK (type IN ('шлем', 'мотоботы', 'комбинезон')),
    brand VARCHAR(50) NOT NULL,
    size VARCHAR(10) NOT NULL,
    material VARCHAR(50) NOT NULL,
    daily_price DECIMAL(10, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE bk_467575_2025.rentals (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed')),
    FOREIGN KEY (client_id) REFERENCES bk_467575_2025.clients(id) ON DELETE CASCADE
);

CREATE TABLE bk_467575_2025.rental_items (
    id SERIAL PRIMARY KEY,
    rental_id INTEGER NOT NULL,
    item_type VARCHAR(10) NOT NULL CHECK (item_type IN ('motor', 'gear')),
    item_id INTEGER NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES bk_467575_2025.rentals(id) ON DELETE CASCADE
);