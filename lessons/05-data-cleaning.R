# ==========================================
# DATA CLEANING
# Dataset: Retail Sales
# ==========================================

# 1. Membaca dataset mentah
sales_clean <- read.csv(
  "data/retail_sales_raw.csv",
  stringsAsFactors = FALSE,
  na.strings = ""
)

# 2. Memeriksa dimensi data sebelum cleaning
cat("=== DATA SEBELUM CLEANING ===\n")
print(dim(sales_clean))

# 3. Menghapus baris duplikat yang identik
sales_clean <- sales_clean[
  !duplicated(sales_clean),
]

cat("\n=== DATA SETELAH CEK DUPLIKAT ===\n")
print(dim(sales_clean))

# 4. Merapikan spasi pada kolom teks
text_columns <- c(
  "product",
  "category",
  "payment_method",
  "branch"
)

for (column in text_columns) {
  sales_clean[[column]] <- trimws(
    sales_clean[[column]]
  )
}

# 5. Menstandarkan kapitalisasi metode pembayaran
sales_clean$payment_method <- tolower(
  sales_clean$payment_method
)

# 6. Mengubah format tanggal
date_raw <- sales_clean$transaction_date

date_iso <- as.Date(
  date_raw,
  format = "%Y-%m-%d"
)

date_dmy <- as.Date(
  date_raw,
  format = "%d/%m/%Y"
)

date_result <- date_iso
use_dmy <- is.na(date_result) & !is.na(date_dmy)
date_result[use_dmy] <- date_dmy[use_dmy]

sales_clean$transaction_date <- date_result

# 7. Memeriksa hasil sementara
cat("\n=== CONTOH DATA SETELAH CLEANING ===\n")
print(head(sales_clean))

cat("\n=== MISSING VALUES ===\n")
print(colSums(is.na(sales_clean)))

cat("\n=== JUMLAH BARIS DUPLIKAT ===\n")
print(sum(duplicated(sales_clean)))

cat("\n=== RINGKASAN DATA ===\n")
print(summary(sales_clean))

# 8. VALIDASI NILAI TIDAK WAJAR
cat("\n=== KUANTITAS NOL ATAU NEGATIF ===\n")
print(
  sales_clean[
    !is.na(sales_clean$quantity) &
      sales_clean$quantity <= 0,
    c("transaction_id", "product", "quantity")
  ]
)

cat("\n=== HARGA NOL ATAU NEGATIF ===\n")
print(
  sales_clean[
    !is.na(sales_clean$unit_price) &
      sales_clean$unit_price <= 0,
    c("transaction_id", "product", "unit_price")
  ]
)

cat("\n=== DISKON DI LUAR RENTANG 0-1 ===\n")
print(
  sales_clean[
    !is.na(sales_clean$discount) &
      (sales_clean$discount < 0 |
         sales_clean$discount > 1),
    c("transaction_id", "discount")
  ]
)

cat("\n=== TANGGAL TIDAK VALID ===\n")
print(
  sales_clean[
    is.na(sales_clean$transaction_date),
    c("transaction_id", "transaction_date")
  ]
) 

# 9. MENANGANI NILAI TIDAK VALID
# Kuantitas negatif atau nol menjadi NA
sales_clean$quantity[
  !is.na(sales_clean$quantity) &
    sales_clean$quantity <= 0
] <- NA

# Harga negatif atau nol menjadi NA
sales_clean$unit_price[
  !is.na(sales_clean$unit_price) &
    sales_clean$unit_price <= 0
] <- NA

# Diskon harus berada pada rentang 0 sampai 1
sales_clean$discount[
  !is.na(sales_clean$discount) &
    (sales_clean$discount < 0 |
       sales_clean$discount > 1)
] <- NA

# 10. MEMERIKSA HASIL PENANGANAN
cat("\n=== MISSING VALUES SETELAH PENANGANAN ===\n")
print(colSums(is.na(sales_clean)))

cat("\n=== KUANTITAS TIDAK VALID YANG TERSISA ===\n")
print(sum(
  !is.na(sales_clean$quantity) &
    sales_clean$quantity <= 0
))

cat("\n=== HARGA TIDAK VALID YANG TERSISA ===\n")
print(sum(
  !is.na(sales_clean$unit_price) &
    sales_clean$unit_price <= 0
))

cat("\n=== DISKON DI LUAR RENTANG ===\n")
print(sum(
  !is.na(sales_clean$discount) &
    (sales_clean$discount < 0 |
       sales_clean$discount > 1)
))

# 11. MENANGANI MISSING VALUES
# Menghapus baris tanpa tanggal transaksi
sales_clean <- sales_clean[
  !is.na(sales_clean$transaction_date),
]

# Menghapus baris tanpa nama produk
sales_clean <- sales_clean[
  !is.na(sales_clean$product) &
    sales_clean$product != "",
]

# Menghapus baris tanpa kuantitas
sales_clean <- sales_clean[
  !is.na(sales_clean$quantity),
]

# Menghapus baris tanpa harga satuan
sales_clean <- sales_clean[
  !is.na(sales_clean$unit_price),
]

# Mengisi diskon kosong dengan 0
sales_clean$discount[
  is.na(sales_clean$discount)
] <- 0

# 12. PEMERIKSAAN SETELAH PENANGANAN
cat("\n=== DIMENSI DATA SETELAH CLEANING ===\n")
print(dim(sales_clean))

cat("\n=== MISSING VALUES TERSISA ===\n")
print(colSums(is.na(sales_clean)))

cat("\n=== JUMLAH BARIS DUPLIKAT ===\n")
print(sum(duplicated(sales_clean)))

cat("\n=== RINGKASAN DATA BERSIH ===\n")
print(summary(sales_clean))

# 13. MENYIMPAN DATASET BERSIH
write.csv(
  sales_clean,
  "data/retail_sales_clean.csv",
  row.names = FALSE,
  na = ""
)

cat("\nDataset bersih berhasil disimpan.\n")
cat("Lokasi: data/retail_sales_clean.csv\n")

# Memeriksa apakah file berhasil dibuat
cat(
  "File tersedia:",
  file.exists("data/retail_sales_clean.csv"),
  "\n"
)

# 14. VALIDASI DATASET HASIL CLEANING
sales_final <- read.csv(
  "data/retail_sales_clean.csv",
  stringsAsFactors = FALSE,
  na.strings = ""
)

cat("\n=== VALIDASI DATASET FINAL ===\n")
print(dim(sales_final))

cat("\nMissing values per kolom:\n")
print(colSums(is.na(sales_final)))

cat("\nBaris duplikat:\n")
print(sum(duplicated(sales_final)))