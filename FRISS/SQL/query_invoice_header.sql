SELECT biz_header.*, biz_header_ext.*, 

settings.adoh_felhasznalonev AS NAV_USERNAME,
settings.adoh_jelszo AS NAV_PASSWORD,
settings.adoh_xml_alairo_kulcs AS NAV_XML_SIGNATURE_KEY,
settings.adoh_xml_cserekulcs AS NAV_XML_EXCHANGE_KEY,
settings.adoh_adoszam AS OWN_TAXNUMBER, 

'HU1486022301234567' AS SOFTWARE_ID,
'Astro ERP' AS SOFTWARE_NAME,
'LOCAL_SOFTWARE' AS SOFTWARE_TYPE,
'6' AS SOFTWARE_MAINVERSION,
'DJ' AS SOFTWARE_DEVELOPER_NAME,
'business.software.design@gmail.com' AS SOFTWARE_DEVELOPER_CONTACT,

'PAPER' AS INVOICE_APPEARANCE,

biz_header.sorszam AS INVOICE_NUMBER,
biz_header.kelte AS ISSUE_DATE,
biz_header.teljesites AS DELIVERY_DATE,
biz_header.hatarido AS PAYMENT_DATE,

(CASE
WHEN biz_header.fizmod='KÉSZPÉNZ' THEN 'CASH'
WHEN biz_header.fizmod='ÁTUTALÁS' THEN 'TRANSFER'
WHEN biz_header.fizmod='BANKKÁRTYA' THEN 'CARD'
WHEN biz_header.fizmod='UTALVÁNY' THEN 'VOUCHER'
ELSE 'OTHER' END) AS PAYMENT_METHOD,

biz_header.penznem AS CURRENCY_CODE,
biz_header.arfolyam AS EXCHANGE_RATE,

biz_header.storno AS INVOICE_INVALIDATOR,
biz_header.helyesbito AS INVOICE_CORRECTIVE,

biz_header.gyujtoszamla AS INVOICE_AGGREGATE,

(Select BHOE.sorszam From biz_header BHOE Where BHOE.id=biz_header.original_header_id And BHOE.biz_modul_kod=1301) as ORIGINAL_INVOICE_NUMBER, 
(Select Count(*) From biz_header BHOC Where BHOC.original_header_id=biz_header.original_header_id) as MODIFICATION_INDEX,

0 AS MODIFY_WITHOUT_MASTER,

settings.ceg_neve as OWN_NAME,
'HU' as OWN_COUNTRY_CODE,
settings.ceg_irsz as OWN_POSTAL_CODE,
settings.ceg_helyseg as OWN_CITY,
Trim(Concat( 
if(trim(settings.ceg_irsz)<>'',concat('  hrsz:',trim(settings.ceg_irsz)),''), 
if(trim(settings.ceg_utca)<>'',concat('  ',trim(settings.ceg_utca)),''), 
if(trim(settings.ceg_hsz)<>'',concat(' ',trim(settings.ceg_hsz)),''), 
if(trim(settings.ceg_epulet)<>'',concat('  ',trim(settings.ceg_epulet),'.épület'),''), 
if(trim(settings.ceg_lepcsohaz)<>'',concat('  ',trim(settings.ceg_lepcsohaz),'.lépcsőház'),''), 
if(trim(settings.ceg_emelet)<>'',concat('  ',trim(settings.ceg_emelet),'.emelet'),''), 
if(trim(settings.ceg_ajto)<>'',concat('  ',trim(settings.ceg_ajto),'.ajtó'),'') 
)) as OWN_ADDRESS, 

biz_header_ext.bankszamlaszam AS OWN_BANK_ACCOUNT,

settings.kisadozo AS OWN_INDIVIDUAL_EXEMPTION,
settings.egyeni_vallalkozo AS OWN_SMALL_BUSINESS,

(SELECT Count(*) AS lastitemserial FROM biz_header BH, biz_item BI WHERE BI.biz_header_id=BH.id AND BH.biz_modul_kod=1301 
AND BH.invoice_to_report=1 AND BH.lezarva=1 AND BH.tag=biz_header.tag 
AND BH.id<biz_header.id) AS LAST_ITEM_LINE_NUMBER,

biz_header_ext.partner_adoszam AS PARTNER_TAXNUMBER,

biz_header_ext.partner_kozadoszam AS PARTNER_EU_TAXNUMBER,

IF( biz_header_ext.partner_adoszam='' AND biz_header_ext.partner_kozadoszam='', true, false) AS PARTNER_PRIVATE_PERSON,

partner.nev AS PARTNER_NAME,

(SELECT orszagkod2 FROM orszag_deviza WHERE LOWER(TRIM(orszag))=LOWER(TRIM(partner.orszag)) LIMIT 1) as PARTNER_COUNTRY_CODE, 

partner.irsz as PARTNER_POSTAL_CODE,

partner.helyseg as PARTNER_CITY,  -- partner.kerulet as partner_kerulet, 

Trim(Concat( 
if(trim(partner.hrsz)<>'',concat('  hrsz:',trim(partner.hrsz)),''), 
if(trim(partner.utca)<>'',concat('  ',trim(partner.utca)),''), 
if(trim(partner.hsz)<>'',concat(' ',trim(partner.hsz)),''), 
if(trim(partner.epulet)<>'',concat('  ',trim(partner.epulet),'.épület'),''), 
if(trim(partner.lepcsohaz)<>'',concat('  ',trim(partner.lepcsohaz),'.lépcsőház'),''), 
if(trim(partner.emelet)<>'',concat('  ',trim(partner.emelet),'.emelet'),''), 
if(trim(partner.ajto)<>'',concat('  ',trim(partner.ajto),'.ajtó'),'') 
)) as PARTNER_ADDRESS, 

(Select BHOS.sorszam From biz_header BHOS Where BHOS.id=biz_header.source_header_id And BHOS.biz_modul_kod=1301) as forras_szamlaszam, 

biz_header_ext.ossz_netto AS NET_TOTAL,
biz_header_ext.ossz_netto_ft AS NET_TOTAL_HUF,

biz_header_ext.ossz_afa AS VAT_TOTAL,
biz_header_ext.ossz_afa_ft AS VAT_TOTAL_HUF,

biz_header_ext.ossz_brutto AS GROSS_TOTAL,
biz_header_ext.ossz_brutto_ft AS GROSS_TOTAL_HUF,

invoice_report_transaction_id as TRANSACTION_ID

FROM biz_header 
LEFT OUTER JOIN biz_header_ext ON biz_header_ext.biz_header_id=biz_header.id 
LEFT OUTER JOIN partner ON partner.id=biz_header.partner_id
LEFT OUTER JOIN settings ON settings.settings_id=0
WHERE biz_header.id=:HEADER_ID
