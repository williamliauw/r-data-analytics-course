# ==========================================
# DATA QUALITY CHECK
# Dataset: Retail Sales Raw
# ==========================================

# 1. Membaca dataset mentah
sales_check <- read.csv(
  "data/retail_sales_raw.csv",
  stringsAsFactors = FALSE,
  na.strings = ""
)

# 2. Memeriksa jumlah baris dan kolom
cat("=== DIMENSI DATASET ===\n")
print(dim(sales_check))

# 3. Melihat lima baris pertama
cat("\n=== LIMA BARIS PERTAMA\n")
print(head(sales_check))

# 4. Memeriksa struktur dan tipe data
cat("\n=== STRUKTUR DATA ===\n")
str(sales_check)

# 5. Menghitung missing values setiap kolom
cat("\n=== MISSING VALUES ===\n")
print(colSums(is.na(sales_check)))

# 6. Menghitung persentase missing values
cat("\n=== PERSENTASE MISSING VALUES (%) ===\n")
print(round(colMeans(is.na(sales_check)) * 100,2))

# 7. Menghitung baris duplikat
cat("\n==== JUMLAH BARIS DUPLIKAT ===\n")
print(sum(duplicated((sales_check))))

# 8. Memeriksa ID transaksi yang berulang
cat("\n=== ID TRANSAKSI BERULANG ===\n")
print(sum(duplicated(sales_check$transaction_id)))

# 9. Melihat ringkasan data numerik dan kategorikal
cat("\n=== RINGKASAN DATA ===\n")
print(summary(sales_check))