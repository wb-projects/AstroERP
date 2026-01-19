SELECT DISTINCT 
afakulcs AS VAT_PERCENTAGE, 
afanev, 
afa.tipus as VAT_CODE, 
afa.afa_tv_hiv as VAT_REASON, 
sum(ossz_netto) as VAT_NET_TOTAL, 
sum(ossz_brutto) as VAT_GROSS_TOTAL, 
sum(ossz_afa) as VAT_AMOUNT, 
sum(ossz_netto_ft) as VAT_NET_TOTAL_HUF, 
sum(ossz_afa_ft) as VAT_AMOUNT_HUF, 
sum(ossz_brutto_ft) as VAT_GROSS_TOTAL_HUF 
FROM biz_item, biz_item_ext, afa 
WHERE biz_item_ext.biz_item_id=biz_item.id 
AND afa.id=biz_item.afa_id 
AND biz_header_id=:HEADER_ID 
GROUP BY afa_id 
ORDER BY afa.tipus, biz_item.afa_id
