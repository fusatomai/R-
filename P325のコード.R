# 教科書P325の図作る
# パッケージの読み込み
library(rstan)
library(bayesplot)
library(ggfortify)
library(gridExtra)

# 計算の高速化
rstan_options(auto_write = TRUE)
options(mc.croes = parallel::detectCores())

# 状態空間モデルの図示をする関数の読み込み
source("plotSSM.R", encoding="utf-8")

# データ読み込み
sales_df_4 <- read.csv("5-6-1-sales-ts-4.csv")
sales_df_4$date <- as.POSIXct(sales_df_4$date)
head(sales_df_4, n=3)

# 上で読み込んだデータを図示
autoplot(ts(sales_df_4[, -1]))

# データの準備
data_list <- list(
  y = sales_df_4$sales,
  T = nrow(sales_df_4)
)

# 基本構造時系列モデルの推定
basic_structual <- stan(
  file = "5-6-1-basic-structual-time-series.stan", # stanファイル
  data = data_list,                                # 対象データ
  seed = 1,                                        # 乱数の種
  iter = 8000,                                     # 乱数生成の繰り返し数
  warmup = 2000,                                   # バーンイン期間（初期値の影響を除去するために取り除かれる最初の数回）
  thin = 6,                                        # 間引き数（サイズの削減）
  control = list(adapt_delta = 0.97, max_treedepth = 15) # P264
)


# 基本構造時系列モデルの推定結果
print(basic_structual, 
      par = c("s_z", "s_s", "s_v", "lp__"),
      probs = c(0.025, 0.5, 0.975))

# MCMCサンプルの取得
mcmc_sample <- rstan::extract(basic_structual)

# 全ての成分を含んだ状態推定値の図示
p_all <- plotSSM(mcmc_sample = mcmc_sample, 
                 time_vec = sales_df_4$date,
                 obs_vec = sales_df_4$sales,
                 state_name = "alpha", 
                 graph_title = "全ての成分を含んだ状態推定値", 
                 y_label = "sales") 

# 周期成分を除いた状態推定値の図示
p_trend <- plotSSM(mcmc_sample = mcmc_sample, 
                   time_vec = sales_df_4$date,
                   obs_vec = sales_df_4$sales,
                   state_name = "mu", 
                   graph_title = "周期成分を除いた状態推定値", 
                   y_label = "sales") 

# 周期成分の図示
p_cycle <- plotSSM(mcmc_sample = mcmc_sample, 
                   time_vec = sales_df_4$date,
                   state_name = "gamma", 
                   graph_title = "周期成分", 
                   y_label = "gamma") 

grid.arrange(p_all, p_trend, p_cycle)
