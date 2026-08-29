import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Подключение к БД
conn = psycopg2.connect(
    dbname="dbstud",
    user="bk_467575_2025",
    password="bk_467575",
    host="postgrepro.dc-edu.ru"
)

# Запрос 1: Топ-5 самых арендуемых моделей мототехники
query1 = """
SELECT m.brand, m.model, COUNT(*) AS rental_count 
FROM motor_equipment m
JOIN rental_items ri ON ri.item_id = m.id AND ri.item_type = 'motor'
GROUP BY m.brand, m.model 
ORDER BY rental_count DESC 
LIMIT 5;
"""
df1 = pd.read_sql(query1, conn)
plt.figure(figsize=(10, 6))
sns.barplot(data=df1, x='rental_count', y='model', hue='brand', palette='viridis')
plt.title("Топ-5 самых арендуемых моделей")
plt.xlabel("Количество аренд")
plt.ylabel("Модель")
plt.tight_layout()
plt.show()

# Запрос 2: Клиенты с просроченной страховкой
query2 = """
SELECT insurance_company, COUNT(*) AS expired_count 
FROM clients 
WHERE insurance_expiry < CURRENT_DATE
GROUP BY insurance_company;
"""
df2 = pd.read_sql(query2, conn)
plt.figure(figsize=(8, 8))
plt.pie(df2['expired_count'], labels=df2['insurance_company'], autopct='%1.1f%%')
plt.title("Распределение просроченных страховок по компаниям")
plt.tight_layout()
plt.show()

# Запрос 3: Средняя продолжительность проката
query3 = "SELECT (end_date - start_date) AS days FROM rentals;"
df3 = pd.read_sql(query3, conn)
plt.figure(figsize=(10, 6))
sns.histplot(data=df3, x='days', bins=10, kde=True)
plt.title("Распределение длительности аренды")
plt.xlabel("Дни")
plt.ylabel("Количество аренд")
plt.tight_layout()
plt.show()

# Запрос 4: Топ-10 клиентов по суммам
query4 = """
SELECT c.name, SUM(r.total_price) AS total_spent 
FROM clients c
JOIN rentals r ON c.id = r.client_id 
GROUP BY c.name 
ORDER BY total_spent DESC 
LIMIT 10;
"""
df4 = pd.read_sql(query4, conn)
plt.figure(figsize=(10, 6))
sns.barplot(data=df4, x='total_spent', y='name', palette='rocket')
plt.title("Топ-10 клиентов по потраченным суммам")
plt.xlabel("Сумма (руб)")
plt.ylabel("Клиент")
plt.tight_layout()
plt.show()

# Запрос 5: Доступные шлемы размера L (улучшенная версия)
query5 = """
SELECT brand, material, daily_price 
FROM gear 
WHERE is_available = TRUE AND type = 'шлем' AND size = 'L';
"""
df5 = pd.read_sql(query5, conn)

plt.figure(figsize=(12, 6))
if df5.empty:
    plt.text(0.5, 0.5, 'Нет доступных шлемов размера L', 
             ha='center', va='center', fontsize=12)
    plt.title("Доступные шлемы (размер L)")
else:
    sns.barplot(data=df5, x='brand', y='daily_price', hue='material')
    plt.title("Цены на доступные шлемы (размер L)")
    plt.xlabel("Бренд")
    plt.ylabel("Цена за день (руб)")
    plt.xticks(rotation=45)
    plt.legend(title='Материал')
    
plt.tight_layout()
plt.show()

# Закрытие соединения
conn.close()