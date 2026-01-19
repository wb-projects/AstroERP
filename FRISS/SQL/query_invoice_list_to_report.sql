SELECT id as HEADER_ID
FROM biz_header
WHERE lezarva=1
AND biz_modul_kod=1301
-- AND invoice_to_report=1
AND year(kelte)>2020
AND invoice_report_in_progress=0
AND invoice_reported=0
AND invoice_report_success=0 
ORDER BY id
