
#%% Inflação de Alimentos - IPCA inteiro 

#%% análise Inflação de alimentos: 
#%% variação mensal e acumulada em 12 meses


library(sidrar) # importar IBGE
library(BETS) # importar BCB e outros
#%% consultar API http://api.sidra.ibge.gov.br/
library(tidyverse) # manipulacao de dados
library(stringr) # manipulacao de strings
library(lubridate) # mexer com data
library(ggplot2) # graficos
library(cowplot) # grafico padronizar
library(knitr) # tabelas

#%% BAIXAR E ARRUMAR BASE: PREÇOS ####

#%% Importar dados IPCA variacao mensal

IPCAalim1 <-  get_sidra(api='/t/1419/n1/all/v/63/p/all/c315/all')
IPCAalim2 <-  get_sidra(api='/t/7060/n1/all/v/63/p/all/c315/all')

IPCAalim <-  bind_rows(IPCAalim1, IPCAalim2)

remove(IPCAalim1)
remove(IPCAalim2)

#%% Renomear

names(IPCAalim)[names(IPCAalim) == 'Geral, grupo, subgrupo, item e subitem'] <- 'grup'
names(IPCAalim)[names(IPCAalim) == 'Mês (Código)'] <- 'mes_cod'

#%% ordernar POR bem e data

IPCAalim <- IPCAalim[order(IPCAalim$grup, IPCAalim$mes_cod),]

IPCAalim <- IPCAalim %>% dplyr::select(mes_cod, grup, Valor)

#%% selecionar apenar alimentos, mudando nome, rearrumando

IPCAalim <-IPCAalim %>% 
  filter(str_detect(grup,"^11")) %>% 
  dplyr::select(mes_cod, grup, Valor) %>% 
  spread(grup, Valor) 

#%% BAIXAR E ARRUMAR BASE: PESOS ####

#%% Importar dados IPCA peso

IPCAalim1_peso <-  get_sidra(api='/t/1419/n1/all/v/66/p/all/c315/all')
IPCAalim2_peso <-  get_sidra(api='/t/7060/n1/all/v/66/p/all/c315/all')

IPCAalim_peso <-  bind_rows(IPCAalim1_peso, IPCAalim2_peso)

remove(IPCAalim1_peso)
remove(IPCAalim2_peso)

#%% Renomear

names(IPCAalim_peso)[names(IPCAalim_peso) == 'Geral, grupo, subgrupo, item e subitem'] <- 'grup'
names(IPCAalim_peso)[names(IPCAalim_peso) == 'Mês (Código)'] <- 'mes_cod'

#%% ordernar POR bem e data

IPCAalim_peso <- IPCAalim_peso[order(IPCAalim_peso$grup, IPCAalim_peso$mes_cod),]

#%% selecionar apenar alimentos, renomear e spread

IPCAalim_peso <-IPCAalim_peso %>% 
  filter(str_detect(grup,"^11")) %>% 
  dplyr::select(mes_cod, grup, Valor) %>% 
  spread(grup, Valor)
