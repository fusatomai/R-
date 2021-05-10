# パッケージを読み込む
library(ggplot2)


# データの読み込み
fish <- read.csv("2-2-1-fish.csv")


# ヒストグラムとカーネル密度推定の重ね合わせ
ggplot(data = fish, mapping = aes(x=length, y=..density..)) +
  geom_histogram(alpha=0.5, bins=20) +
  geom_density(size=1.5) +
  labs(title="グラフの重ね合わせ")


# データフレームで乱数生成
data_frame_1 <- data.frame(
  col1 = 1:100,
  col2 = rnorm(n=100, mean=0, sd=1)
)


# ↑の乱数を用いた折れ線グラフ
ggplot(data_frame_1, aes(x=col1, y=col2)) +
  geom_line()


# 教科書P106 "箱ひげ図"
# Petal.Length(花弁の長さ)の箱ひげ図を種類別に描く
p_box <- ggplot(data = iris,                # アヤメのデータ
                mapping = aes(x = Species,          # x軸
                              y = Petal.Length)) +  # y軸
  geom_boxplot() +      # 箱ひげ図を出す
  labs(title = "箱ひげ図")  # タイトル


# 教科書P107 "散布図"
# アヤメの花弁の長さと幅を散布図で表す
ggplot(iris, aes(x = Petal.Width,      # x軸
                 y = Petal.Length,     # y軸
                 color = Species)) +   # 種類別に色分け
  geom_point()                         # 散布図を出す

