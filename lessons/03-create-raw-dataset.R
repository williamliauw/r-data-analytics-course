
# ==========================================
# GENERATE RAW RETAIL SALES DATASET
# 5,000 rows | Synthetic data
# ==========================================

set.seed(123)

n <- 5000

products <- c(
  "Laptop", "Mouse", "Keyboard", "Monitor",
  "Headphones", "Webcam", "Printer", "USB Drive"
)

categories <- c(
  "Electronics", "Accessories", "Accessories",
  "Electronics", "Accessories", "Accessories",
  "Electronics", "Accessories"
)

product_prices <- c(
  7500000, 150000, 350000, 2200000,
  450000, 600000, 1800000, 100000
)

product_index <- sample(
  seq_along(products),
  n,
  replace = TRUE
)

sales_raw <- data.frame(
  transaction_id = sprintf("TRX%05d", 1:n),
  transaction_date = format(
    sample(
      seq(as.Date("2026-01-01"),
          as.Date("2026-09-30"),
          by = "day"),
      n,
      replace = TRUE
    ),
    "%Y-%m-%d"
  ),
  customer_id = sprintf(
    "CUS%04d",
    sample(1:1200, n, replace = TRUE)
  ),
  product = products[product_index],
  category = categories[product_index],
  quantity = sample(1:10, n, replace = TRUE),
  unit_price = product_prices[product_index],
  discount = sample(
    c(0, 0.05, 0.10, 0.15, 0.20),
    n,
    replace = TRUE
  ),
  payment_method = sample(
    c("Cash", "Debit Card", "Credit Card", "E-Wallet"),
    n,
    replace = TRUE
  ),
  branch = sample(
    c("Jakarta", "Bandung", "Surabaya",
      "Yogyakarta", "Medan"),
    n,
    replace = TRUE
  ),
  stringsAsFactors = FALSE
)

# ------------------------------------------
# SIMULASI MASALAH KUALITAS DATA
# ------------------------------------------

# 1. Missing values
sales_raw$customer_id[
  sample(1:n, 40)
] <- NA

sales_raw$product[
  sample(1:n, 25)
] <- NA

sales_raw$unit_price[
  sample(1:n, 30)
] <- NA

sales_raw$branch[
  sample(1:n, 20)
] <- NA

# 2. Format teks tidak konsisten
idx <- sample(1:n, 60)
sales_raw$branch[idx] <- paste0(
  " ", sales_raw$branch[idx], " "
)

idx <- sample(1:n, 50)
sales_raw$payment_method[idx] <- tolower(
  sales_raw$payment_method[idx]
)

# 3. Nilai tidak valid
sales_raw$quantity[
  sample(1:n, 12)
] <- -sample(1:5, 12, replace = TRUE)

sales_raw$unit_price[
  sample(1:n, 10)
] <- -sample(10000:50000, 10)

sales_raw$discount[
  sample(1:n, 10)
] <- 1.5

# 4. Format tanggal tidak konsisten
idx <- sample(1:n, 30)
dates <- as.Date(sales_raw$transaction_date[idx])
sales_raw$transaction_date[idx] <- format(
  dates, "%d/%m/%Y"
)

idx <- sample(1:n, 5)
sales_raw$transaction_date[idx] <- "invalid-date"

# 5. Duplikasi baris secara sengaja
duplicate_rows <- sample(1:(n - 100), 25)
sales_raw[(n - 24):n, ] <-
  sales_raw[duplicate_rows, ]

# ------------------------------------------
# SIMPAN DATA MENTAH
# ------------------------------------------

write.csv(
  sales_raw,
  "data/retail_sales_raw.csv",
  row.names = FALSE,
  na = ""
)

# ------------------------------------------
# PEMERIKSAAN AWAL
# ------------------------------------------

cat("Jumlah baris:", nrow(sales_raw), "\n")
cat("Jumlah kolom:", ncol(sales_raw), "\n")
cat("Missing values per kolom:\n")

print(colSums(is.na(sales_raw)))

cat(
  "Jumlah baris duplikat:",
  sum(duplicated(sales_raw)),
  "\n"
)

cat("Dataset berhasil disimpan.\n")