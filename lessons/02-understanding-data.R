# Understanding Data
# Dataset: Sample Sales

# 1. Membaca dataset
sales <- read.csv("data/sample_sales.csv")

# 2. Melihat lima baris pertama
head(sales)

# 3. Melihat struktur data
str(sales)

# 4. Melihat jumlah baris dan kolom
dim(sales)

# 5. Melihat nama kolom
names(sales)

# 6. Melihat ringkasan statistik
summary(sales)

# 7. Memeriksa tipe data setiap kolom
sapply(sales, class)
