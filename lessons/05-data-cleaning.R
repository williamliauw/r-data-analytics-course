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