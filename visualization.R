setwd("/Users/soom/Desktop/IEP LAB")

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
library(reshape2)
library(ggmosaic)
library(nnet)
library(broom)

install.packages("broom")

rawfile<-"/Users/soom/Desktop/IEP LAB/rawdata.csv"
rawdata <- read_csv(rawfile)

 
#############q49

rawdata$q49 <- factor(rawdata$q49, levels = c(1, 2), 
                      labels = c("중소기업은 대기업에 비해 열악한 위치에 있으므로 정부가 도와야 하므로 찬성한다",
                                 "경쟁력과 무관하게 단지 작다는 이유로 지원하는 것은 반대한다"))


# 각 agegroup과 sex별로 q49 응답의 찬성 퍼센티지 계산
percentage_data_q49 <- rawdata %>%
  group_by(agegroup, sex) %>%
  summarise(total_responses = n(),
            agree_count = sum(q49 == "중소기업은 대기업에 비해 열악한 위치에 있으므로 정부가 도와야 하므로 찬성한다")) %>%
  mutate(percentage = (agree_count / total_responses) * 100) %>%
  ungroup()

##percentage by age group
percentage_data_agegroup <- rawdata %>%
  group_by(agegroup) %>%
  summarise(total_responses = n(),
            agree_count = sum(q49 == "중소기업은 대기업에 비해 열악한 위치에 있으므로 정부가 도와야 하므로 찬성한다"),
            disagree_count = sum(q49 == "경쟁력과 무관하게 단지 작다는 이유로 지원하는 것은 반대한다")) %>%
  mutate(agree_percentage = (agree_count / total_responses) * 100,
         disagree_percentage = (disagree_count / total_responses) * 100) %>%
  ungroup()

##percentage in total
percentage_data_total <- rawdata %>%
  summarise(total_responses = n(),
            agree_count = sum(q49 == "중소기업은 대기업에 비해 열악한 위치에 있으므로 정부가 도와야 하므로 찬성한다"),
            disagree_count = sum(q49 == "경쟁력과 무관하게 단지 작다는 이유로 지원하는 것은 반대한다")) %>%
  mutate(agree_percentage = (agree_count / total_responses) * 100,
         disagree_percentage = (disagree_count / total_responses) * 100)

# 시각화
q49plot <- ggplot(percentage_data_q49, aes(x = agegroup, y = percentage, color = sex, group = sex)) +
  geom_line(size = 1) +
  geom_point(size = 2) +  # 데이터포인트 강조(동그라미 크기)
  labs(x = "연령대", y = "찬성비율(%)", color = "성별", title = "중소기업은 대기업에 비해 열악한 위치에 있으므로 정부 지원이 필수이다") +
  scale_color_manual(values = c("여자" = "red", "남자" = "blue")) +
  theme_bw()+
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))



#############q49

rawdata$q63 <- factor(rawdata$q63, levels = c(1, 2), 
                      labels = c("소상공인의 부담을 증가시키므로 폐기 또는 완화되어야 한다",
                                 "환경을 위해 필요하다. 유지 또는 강화되어야 한다"))


# 각 agegroup과 sex별로 q63 응답의 찬성 퍼센티지 계산
percentage_data_q63 <- rawdata %>%
  group_by(agegroup, sex) %>%
  summarise(total_responses = n(),
            agree_count = sum(q63 == "환경을 위해 필요하다. 유지 또는 강화되어야 한다")) %>%
  mutate(percentage = (agree_count / total_responses) * 100) %>%
  ungroup()


##percentage by age group
percentage_q63_agegroup <- rawdata %>%
  group_by(agegroup) %>%
  summarise(total_responses = n(),
            agree_count = sum(q63 == "환경을 위해 필요하다. 유지 또는 강화되어야 한다"),
            disagree_count = sum(q63 == "소상공인의 부담을 증가시키므로 폐기 또는 완화되어야 한다")) %>%
  mutate(agree_percentage = (agree_count / total_responses) * 100,
         disagree_percentage = (disagree_count / total_responses) * 100) %>%
  ungroup()



##percentage in total
percentage_q63_total <- rawdata %>%
  summarise(total_responses = n(),
            agree_count = sum(q63 == "환경을 위해 필요하다. 유지 또는 강화되어야 한다"),
            disagree_count = sum(q63 == "소상공인의 부담을 증가시키므로 폐기 또는 완화되어야 한다")) %>%
  mutate(agree_percentage = (agree_count / total_responses) * 100,
         disagree_percentage = (disagree_count / total_responses) * 100)

# 시각화
q63plot <- ggplot(percentage_data_q63, aes(x = agegroup, y = percentage, color = sex, group = sex)) +
  geom_line(size = 1) +
  geom_point(size = 2) +  # 데이터포인트 강조(동그라미 크기)
  labs(x = "연령대", y = "찬성비율(%)", color = "성별", 
       title = "일회용 봉투 및 플라스틱 컵 규제는 유지 또는 강화되어야 한다") +
  scale_color_manual(values = c("여자" = "red", "남자" = "blue")) +
  theme_bw()+
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))

###############q56

### q56 - 중소기업 적합 업종 (퍼센티지%)
agegroup_pct_data <- rawdata %>%
  group_by(agegroup, q56) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(agegroup) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100) %>%
  select(-count, -total) %>%
  spread(key = q56, value = percentage, fill = 0)

agegroup_pct_long <- melt(agegroup_pct_data, id.vars = "agegroup", variable.name = "q56", value.name = "percentage")

#heatmap 시각화
q56_heatmap<-ggplot(agegroup_pct_long, aes(x = agegroup, y = q56, fill = percentage)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "red") +
  labs(x = "연령대", y = "설문 점수 (1-5)", fill = "응답비율(%)", 
       title = "정부 정책 효과 평가 : (1) 중소기업 적합 업종") +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), color = "black", size = 3) +
  scale_y_discrete(labels = c("1" = "1=전혀 효과 없다", "2" = "2", "3" = "3", "4" = "4", "5" = "5=매우 효과 있다")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))

###q57 대형마트 영업시간 제한 
metro_pct_data <- rawdata %>%
  group_by(metro, q57) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(metro) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100) %>%
  select(-count, -total) %>%
  spread(key = q57, value = percentage, fill = 0)

metro_pct_long <- melt(agegroup_pct_data, id.vars = "metro", 
                          variable.name = "q57", value.name = "percentage")

q57_heatmap<-ggplot(metro_pct_long, aes(x = metro, y = q57, fill = percentage)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "aquamarine4") +
  labs(x = "수도권/비수도권", y = "설문 점수(1-5_", fill = "응답비율(%)", 
       title = "정부 정책 효과 평가 : (2) 대형마트 영업시간 제한") +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), color = "black", size = 3) +
  scale_y_discrete(labels = c("1" = "1=전혀 효과 없다", "2" = "2", "3" = "3", "4" = "4", "5" = "5=매우 효과 있다")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))


###q58 임대료 등 직접 지원 by 연령대
agegroup_pct_q58 <- rawdata %>%
  group_by(agegroup, q58) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(agegroup) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100) %>%
  select(-count, -total) %>%
  spread(key = q58, value = percentage, fill = 0)

agegroup_pct_q58_long <- melt(agegroup_pct_q58, id.vars = "agegroup", 
                              variable.name = "q58", value.name = "percentage")

q58_heatmap<-ggplot(agegroup_pct_q58_long, aes(x = agegroup, y = q58, fill = percentage)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "steelblue3") +
  labs(x = "연령대", y = "설문점수(1-5)", fill = "응답비율(%)", 
       title = "정부 정책 효과 평가 : (3) 임대료 등 직접 지원") +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), color = "black", size = 3) +
  scale_y_discrete(labels = c("1" = "1=전혀 효과 없다", "2" = "2", "3" = "3", "4" = "4", "5" = "5=매우 효과 있다")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))


###q58 임대료 등 직접 지원 by 교육수준
educ_pct_q58 <- rawdata %>%
  group_by(educ, q58) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(educ) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100) %>%
  select(-count, -total) %>%
  spread(key = q58, value = percentage, fill = 0)

educ_pct_q58_long <- melt(educ_pct_q58, id.vars = "educ", 
                              variable.name = "q58", value.name = "percentage")

q58_heatmap_edu<-ggplot(educ_pct_q58_long, aes(x = educ, y = q58, fill = percentage)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "steelblue3") +
  labs(x = "교육수준", y = "설문점수(1-5)", fill = "응답비율(%)", 
       title = "정부 정책 효과 평가 : (3) 임대료 등 직접 지원") +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), color = "black", size = 3) +
  scale_y_discrete(labels = c("1" = "1=전혀 효과 없다", "2" = "2", "3" = "3", "4" = "4", "5" = "5=매우 효과 있다")) +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))



agegroup_pct_q52 <- rawdata %>%
  group_by(agegroup, q52) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(agegroup) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100)

# 데이터를 긴 형식으로 변환
agegroup_pct_long <- agegroup_pct_q52 %>%
  mutate(q52 = factor(q52, levels = c(1, 2, 3), labels = c("로컬 상점 이용 감소", "이전과 비슷", "잘 모르겠다")))

q52<-ggplot(agegroup_pct_long, aes(x = agegroup, y = percentage, fill = q52)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "연령대", y = "비율 (%)", 
       title = "연령대별 로컬 통화 폐지 정책에 대한 응답 분포",
       fill = "응답내용") +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))


age_sex_pct_q52 <- rawdata %>%
  group_by(agegroup, sex, q52) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(agegroup, sex) %>%
  mutate(total = sum(count)) %>%
  mutate(percentage = (count / total) * 100)

age_sex_pct_long <- age_sex_pct_q52 %>%
  mutate(q52 = factor(q52, levels = c(1, 2, 3), 
                      labels = c("로컬 상점 이용 감소", "이전과 비슷", "잘 모르겠다")))

ggplot(age_sex_pct_long, aes(x = agegroup, y = percentage, fill = q52)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ sex) +
  labs(x = "연령대", y = "퍼센티지 (%)", 
       title = "연령대 및 성별별 로컬 통화 폐지 정책에 대한 응답 분포 (q52)",
       fill = "응답") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


ggplot(age_sex_pct_long, aes(x = agegroup, y = percentage, fill = q52)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9), alpha = 0.7) +
  geom_line(aes(group = interaction(q52, sex), color = sex), position = position_dodge(width = 0.9), size = 1) +
  geom_point(aes(group = interaction(q52, sex), color = sex), position = position_dodge(width = 0.9), size = 2) +
  labs(x = "연령대", y = "퍼센티지 (%)", 
       title = "연령대 및 성별별 로컬 통화 폐지 정책에 대한 응답 분포 (q52)",
       fill = "응답", color = "성별") +
  theme_minimal() +
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))


######q52 (지역화폐 관련)

# 'localcurrency' 변수 생성 및 값 할당
rawdata <- rawdata %>%
  mutate(localcurrency = q52)

# 값이 3인 경우를 NA로 설정
rawdata <- rawdata %>%
  mutate(localcurrency = ifelse(localcurrency == 3, NA, localcurrency))

# 'localcurrency' 변수의 값 레이블링
rawdata$localcurrency <- factor(rawdata$localcurrency,
                                levels = c(1, 2),
                                labels = c("나는 지역 가게 이용을 줄일 것이다", 
                                           "비슷할 것이다"))


# 각 agegroup과 sex별로 q52(localcurrency 변수명) 응답의 찬성 퍼센티지 계산
percentage_data_lcurrency <- rawdata %>%
  group_by(agegroup, sex) %>%
  summarise(
    total_responses = sum(!is.na(localcurrency)),
    agree_count = sum(localcurrency == "나는 지역 가게 이용을 줄일 것이다", na.rm = TRUE)
  ) %>%
  mutate(percentage = (agree_count / total_responses) * 100) %>%
  ungroup()


##percentage by age group
percentage_q52_agegroup <- rawdata %>%
  group_by(agegroup) %>%
  summarise(
    total_responses = sum(!is.na(localcurrency)),
    agree_count = sum(localcurrency == "나는 지역 가게 이용을 줄일 것이다", na.rm = TRUE),
    disagree_count = sum(localcurrency == "비슷할 것이다", na.rm = TRUE)
  ) %>%
  mutate(
    agree_percentage = (agree_count / total_responses) * 100,
    disagree_percentage = (disagree_count / total_responses) * 100
  ) %>%
  ungroup()


##percentage in total
percentage_q52_total <- rawdata %>%
  summarise(
    total_responses = sum(!is.na(localcurrency)),
    agree_count = sum(localcurrency == "나는 지역 가게 이용을 줄일 것이다", na.rm = TRUE),
    disagree_count = sum(localcurrency == "비슷할 것이다", na.rm = TRUE)
  ) %>%
  mutate(agree_percentage = (agree_count / total_responses) * 100,
         disagree_percentage = (disagree_count / total_responses) * 100)

# 시각화
q52plot <- ggplot(percentage_data_lcurrency, aes(x = agegroup, y = percentage, color = sex, group = sex)) +
  geom_line(size = 1) +
  geom_point(size = 2) +  
  scale_y_continuous(limits = c(40, 80), breaks = seq(40, 80, by = 10)) +
  labs(x = "연령대", y = "응답비율(%)", color = "성별", 
       title = "지역화폐 혜택 폐지 시 지역 가게 이용을 줄일 것이다") +
  scale_color_manual(values = c("여자" = "red", "남자" = "blue")) +
  theme_bw()+
  theme(text = element_text(family = "NanumGothic"), 
        axis.text.x = element_text(angle = 0, hjust = 1))

