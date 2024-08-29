function Index=MACD(P)
Index.dif =EMA(P,12)-EMA(P,26);
Index.dea = EMA(Index.dif,9);
Index.macd = 2*(Index.dif-Index.dea);
end