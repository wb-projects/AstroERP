SELECT BI.id AS ITEM_ID,

-- IF(BI.tipus='E' AND BI.mennyiseg>0, true, false ) AS ADVANCE_ITEM,
-- IF(BI.tipus='E' AND BI.mennyiseg<0, true, false ) AS ADVANCE_FINAL_ITEM,

-- (Select BH2.id From biz_header BH2, biz_item BI2 Where BH2.lezarva=1 AND BH2.biz_modul_kod=1301 AND BH2.id=BI2.biz_header_id And BI2.tipus='E' And BI2.mennyiseg=ABS(BI.mennyiseg) And BI2.egysegar=BI.egysegar Order By BI2.id Desc Limit 1) as ORIGINAL_INVOICE_NUMBER,
-- (Select BH2.hatarido From biz_header BH2, biz_item BI2 Where BH2.lezarva=1 AND BH2.biz_modul_kod=1301 AND BH2.id=BI2.biz_header_id And BI2.tipus='E' And BI2.mennyiseg=ABS(BI.mennyiseg) And BI2.egysegar=BI.egysegar Order By BI2.id Desc Limit 1) as ORIGINAL_PAYMENT_DATE,

-- (Select BH2.arfolyam From biz_header BH2, biz_item BI2 Where BH2.lezarva=1 AND BH2.biz_modul_kod in (1301,1302) AND BH2.id=BI2.biz_header_id And BI2.mennyiseg=ABS(BI.mennyiseg) And BI2.egysegar=BI.egysegar Order By BI2.id Desc Limit 1) as ORIGINAL_EXCHANGE_RATE,

-- (Select BH2.teljesites From biz_header BH2, biz_item BI2 Where BH2.lezarva=1 AND BH2.biz_modul_kod in (1301,1302) AND BH2.id=BI2.biz_header_id And BI2.egysegar=BI.egysegar Order By BI2.id Desc Limit 1) as ORIGINAL_DELIVERY_DATE,
-- (Select BH2.sorszam From biz_header BH2, biz_item BI2 Where BH2.lezarva=1 AND BH2.biz_modul_kod=1302 AND BH2.id=BI2.biz_header_id And BI2.egysegar=BI.egysegar Order By BI2.id Desc Limit 1) as ORIGINAL_DELIVERY_NOTE,

IF( BI.tipus='S','SERVICE', IF(BI.tipus='E','OTHER','PRODUCT') ) AS PRODUCT_NATURE,
BIE.megnevezes AS ITEM_DESCRIPTION,

AT.vtsz AS PRODUCT_VTSZ, 
AT.teszor AS PRODUCT_TESZOR, 
AT.cikkszam AS PRODUCT_OWN, 
AT.vonalkod AS PRODUCT_OTHER,

BI.mennyiseg AS ITEM_QUANTITY,
BI.egyseg AS UNIT_OF_MEASURE,

BIE.egysegar_csk AS UNIT_PRICE,
BIE.egysegar_ft AS UNIT_PRICE_HUF,

BIE.ossz_netto AS ITEM_NET_TOTAL,
BIE.ossz_netto_ft AS ITEM_NET_TOTAL_HUF,

afa.tipus as VAT_CODE,
afa.afa_tv_hiv as VAT_REASON,
BIE.afakulcs as VAT_PERCENTAGE,

BIE.ossz_afa AS ITEM_VAT_AMOUNT,
BIE.ossz_afa_ft AS ITEM_VAT_AMOUNT_HUF,

BIE.ossz_brutto AS ITEM_GROSS_TOTAL,
BIE.ossz_brutto_ft AS ITEM_GROSS_TOTAL_HUF

FROM biz_item BI  
LEFT OUTER JOIN biz_item_ext BIE  ON BIE.biz_item_id=BI.id  
LEFT OUTER JOIN arutorzs AT  ON AT.id=BI.arutorzs_id  
LEFT OUTER JOIN afa ON afa.id=BI.afa_id 
WHERE BI.biz_header_id=:HEADER_ID
ORDER BY BI.ssz, BI.id 
