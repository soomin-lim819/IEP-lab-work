setwd("/Users/soom/Desktop/IEP LAB")

#Install necessary library

install.packages("extrafont")
install.packages("readr")
install.packages("vcd")
install.packages("writexl")

library(haven)
library(tidyverse)
library(dplyr)
library(knitr)
library(gridExtra)
library(ggplot2)


library(extrafont)
library(readr)
library(vcd)
library(tidyr)
library(writexl)

font_import(prompt = FALSE)
loadfonts(device = "pdf") 

#Loading dta file into R 
rawfile<-"/Users/soom/Desktop/IEP LAB/rawdata.csv"
rawdata <- read_csv(rawfile)
head(rawdata)

str(rawdata)
glimpse(rawdata)


#create graphs about demographic

# 1. Age distribution by sex
agebysex<-ggplot(data = rawdata) +
  geom_bar(aes(x = agegroup, fill = sex), bins = 30, alpha = 0.9, position = 'dodge') +
  labs(x = "나이", y = "수", fill = "성별", title = "성별에 따른 나이 분포") +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) +  
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"))

agebysex_violin <- ggplot(data = rawdata) +
  geom_violin(aes(x = sex, y = as.numeric(age), fill = sex), alpha = 0.7) +
  labs(x = "성별", y = "나이", fill = "성별", title = "성별에 따른 나이 분포") +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) +  
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"))

# 2. Income distribution by sex
incomebysex<-ggplot(data = rawdata) +
  geom_bar(aes(x = inc, fill = sex), position = "dodge") +
  labs(x = "수입", y = "수", fill = "성별", title = "성별에 따른 수입 분포") +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

incomebysex2_stacked <- ggplot(data = rawdata) +
  geom_bar(aes(x = inc, fill = sex), position = "fill") +
  labs(x = "수입", y = "비율", fill = "성별", title = "성별에 따른 수입 비율") +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

# 3. Asset size by age group
assetbyage<-ggplot(data = rawdata) +
  geom_bar(aes(x = agegroup, fill = asset), position = "dodge") +
  labs(x = "연령대", y = "수", fill = "자산 규모", title = "연령대에 따른 자산 규모") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

asset_age_counts <- rawdata %>%
  count(agegroup, asset)

assetbyage_heatmap <- ggplot(data = asset_age_counts, aes(x = agegroup, y = asset, fill = n)) +
  geom_tile() +
  labs(x = "연령대", y = "자산 규모", fill = "Counts", title = "연령대에 따른 자산 규모") +
  scale_fill_gradient(low = "white", high = "orange") +  # Change colors as needed
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1), text = element_text(family = "NanumGothic"))


# 4. Education level by sex
educbysex<-ggplot(data = rawdata) +
  geom_bar(aes(x = educ, fill = sex), position = "dodge") +
  labs(x = "교육 수준", y = "수", fill = "성별", title = "성별에 따른 교육 수준") +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1), text = element_text(family = "NanumGothic"))

# 5. Housing type by region
housingbyregion<-ggplot(data = rawdata) +
  geom_bar(aes(x = region, fill = housing), position = "dodge") +
  labs(x = "지역", y = "수", fill = "주거 유형", title = "지역에 따른 주거 유형") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        text = element_text(family = "NanumGothic"))

# Heatmap for Housing Types by Region with custom colors

housing_region_counts <- rawdata %>%
  count(region, housing)

# Calculate percentages
housing_region_counts <- housing_region_counts %>%
  group_by(region) %>%
  mutate(percentage = n / sum(n) * 100)

# Heatmap for Housing Types by Region with custom colors and percentages
housingbyregion_heatmap <- ggplot(data = housing_region_counts, aes(x = region, y = housing, fill = percentage)) +
  geom_tile() +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), color = "black", size = 3) +
  labs(x = "지역", y = "주거 유형", fill = "%", title = "지역에 따른 주거 유형 비율") +
  scale_fill_gradient(low = "white", high = "darkorange") +  # Change colors as needed
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))


# 6. Income distribution by metropolitan status
incomebymetro<-ggplot(data = rawdata) +
  geom_bar(aes(x = inc, fill = metro), position = "dodge") +
  labs(x = "수입", fill = "거주 지역", title = "거주 지역에 따른 수입 분포") +
  scale_fill_manual(values = c("수도권" = "orange", "비수도권" = "darkgreen")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))


# 7. Age distribution by metropolitan status
agebymetro<-ggplot(data = rawdata) +
  geom_bar(aes(x = agegroup, fill = metro), position = 'dodge') +
  labs(x = "연령대", y = "수", fill = "거주 지역", title = "거주 지역에 따른 연령대 분포") +
  scale_fill_manual(values = c("수도권" = "orange", "비수도권" = "darkgreen")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), axis.text.x = element_text(angle = 45, hjust = 1))

# 7-1 Age distribution by marital status
agebymar<-ggplot(data = rawdata) +
  geom_violin(aes(x = mar, y = as.numeric(age), fill = sex)) +
  labs(x = "혼인 상태", y = "나이", fill = "성별", title = "혼인 상태에 따른 나이 분포") +
  scale_fill_manual(values = c("남자" = "lightblue", "여자" = "pink")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"))

# 8. Marital Status by Region
marbyregion<-ggplot(data = rawdata) +
  geom_bar(aes(x = region, fill = mar), position = "fill") +
  labs(x = "지역", y = "비율", fill = "혼인 상태", title = "지역에 따른 혼인 상태 비율") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

marbymetro<-ggplot(data = rawdata) +
  geom_bar(aes(x = metro, fill = mar), position = "fill") +
  labs(x = "지역", y = "비율", fill = "혼인 상태", title = "지역에 따른 혼인 상태 비율") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1), text = element_text(family = "NanumGothic"))


# 9. Job Distribution by Region
jobbyregion<-ggplot(data = rawdata) +
  geom_bar(aes(x = region, fill = job), position = "dodge") +
  labs(x = "지역", y = "수", fill = "직업", title = "지역에 따른 직업 분포") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

jobbymetro<-ggplot(data = rawdata) +
  geom_bar(aes(x = metro, fill = job), position = "dodge") +
  labs(x = "지역", y = "수", fill = "직업", title = "지역에 따른 직업 분포") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))


## Heatmap for Job Distribution by Region with custom colors
job_region_counts <- rawdata %>%
  count(job, region) %>%
  group_by(region) %>%
  mutate(total = sum(n), percent = (n / total) * 100)

# Create the heatmap using the percentage values
jobbyregion_heatmap <- ggplot(data = job_region_counts, aes(x = region, y = job, fill = percent)) +
  geom_tile() +
  labs(x = "지역", y = "직업", fill = "퍼센티지", title = "지역에 따른 직업 분포") +
  scale_fill_gradient(low = "white", high = "darkorange") +  # Change colors as needed
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))


#10. Job Distribution by Sex

jobbysex<-ggplot(data = rawdata) +
geom_bar(aes(x = job, fill = sex), position = "dodge") +
  labs(x = "직업", y = "수", fill = "성별", title = "성별에 따른 직업 분포") +
  scale_fill_manual(values = c("남자" = "skyblue", "여자" = "pink")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(family = "NanumGothic"))

jobbysex_violin <- ggplot(data = rawdata) +
  geom_violin(aes(y = sex, x = as.numeric(factor(job)), fill = sex), alpha = 0.7) +
  labs(y = "성별", x = "직업", fill = "성별", title = "성별에 따른 직업 분포") +
  scale_x_continuous(breaks = 1:5, labels = c("개발자", "무직", "사무직", "생산직", "전문직")) +
  theme_minimal() +
  scale_fill_manual(values = c("남자" = "blue", "여자" = "pink")) +  
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"))


######설문지 분석 (descriptive Data)


# q45 변수와 sex 변수 레이블 설정
rawdata$q45 <- factor(rawdata$q45, levels = c(1, 2), labels = c("찬성한다", "반대한다"))
rawdata$sex <- factor(rawdata$sex, levels = c(0, 1), labels = c("여자", "남자"))

# 각 agegroup과 sex별로 q45 응답의 퍼센티지 계산
percentage_data <- rawdata %>%
  group_by(agegroup, sex, q45) %>%
  summarise(count = n()) %>%
  mutate(percentage = (count / sum(count)) * 100) %>%
  ungroup()

# 결과 확인
print(percentage_data)

# 시각화
ggplot(percentage_data, aes(x = agegroup, y = percentage, color = q45, group = interaction(sex, q45))) +
  geom_line(size = 1) +
  geom_point(size = 2) +  # 데이터 포인트 강조를 위해 추가
  facet_wrap(~ sex) +
  labs(x = "연령대", y = "퍼센티지", color = "응답", title = "연령대 및 성별에 따른 설문 응답 분포") +
  scale_color_manual(values = c("찬성한다" = "blue", "반대한다" = "red")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), axis.text.x = element_text(angle = 45, hjust = 1))
