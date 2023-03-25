/*

Data cleaning in sql 

*/

select *
from datacleaning..dataclean

--Standardize date format 

select saledateconverted, convert(date,SaleDate)
from datacleaning..dataclean


Alter Table dataclean
add saledateconverted date;

update dataclean
set saledateconverted = convert(date,SaleDate)

--populate property address data  

select propertyaddress
from datacleaning..dataclean
--where PropertyAddress is null
order by ParcelID

select A.ParcelID,A.PropertyAddress ,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from datacleaning..dataclean A
join datacleaning..dataclean B
   on A.ParcelID = B.ParcelID
   and A.[UniqueID ] <> B.[UniqueID ]
--where A.PropertyAddress is Null


update A
set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from datacleaning..dataclean A
join datacleaning..dataclean B
   on A.ParcelID = B.ParcelID
   and A.[UniqueID ] <> B.[UniqueID ]

--breaking out address into individual column (address,city , state)

select propertyaddress 
from datacleaning.dbo.dataclean 

select
SUBSTRING(propertyaddress , 1, CHARINDEX(',' , propertyaddress )-1) as address
, SUBSTRING(propertyaddress , CHARINDEX(',' , propertyaddress ) +1, LEN(propertyaddress)) as address
from datacleaning..dataclean 


Alter Table dataclean
add propertysplitaddress nvarchar(255);

update dataclean
set propertysplitaddress  = SUBSTRING(propertyaddress , 1, CHARINDEX(',' , propertyaddress )-1) 



Alter Table dataclean
add propertysplitcity nvarchar(255);

Update dataclean
set propertysplitcity = SUBSTRING(propertyaddress , CHARINDEX(',' , propertyaddress ) +1, LEN(propertyaddress)) 

select OwnerAddress
from datacleaning..dataclean

select 
PARSENAME(REPLACE(owneraddress,',','.'),3)
,pARSENAME(REPLACE(owneraddress,',','.'),2)
,pARSENAME(REPLACE(owneraddress,',','.'),1)
from datacleaning..dataclean


Alter Table dataclean
add ownersplitaddress nvarchar(255);

update dataclean
set ownersplitaddress  = PARSENAME(REPLACE(owneraddress,',','.'),3)


Alter Table dataclean
add ownersplitcity nvarchar(255);

update dataclean
set ownersplitcity  = PARSENAME(REPLACE(owneraddress,',','.'),2)


Alter Table dataclean
add ownersplitstate nvarchar(255);

update dataclean
set ownersplitstate  = PARSENAME(REPLACE(owneraddress,',','.'),3)

select * 
from datacleaning..dataclean

------------------------------------------------------------------------------------------------------------------------------------

--change Y and N to yes and no in 'sold as vacant' field

select distinct(SoldAsVacant),count(soldasvacant)
from datacleaning..dataclean
group by SoldAsVacant
order by 2

select soldasvacant 
,case when soldasvacant = 'y' then 'Yes'
      when soldasvacant = 'n' then 'No'
     else soldasvacant
     end
from  datacleaning..dataclean

update dataclean 
set soldasvacant = case when soldasvacant = 'y' then 'Yes'
      when soldasvacant = 'n' then 'No'
     else soldasvacant
     end
	 

-------------------------------------------------------------------------------------------------------------------------------
--- remove duplicates 
with RowNumCTE as(
select *,
  ROW_NUMBER() Over (
  partition by parcelid,
               propertyaddress,
			   saleprice,
			   saledate,
			   legalreference
			   order by
			      uniqueid
				  )row_num
from  datacleaning..dataclean 
)
SELECT*
FROM RowNumCTE
where row_num > 1
order by PropertyAddress

select *
from  datacleaning..dataclean

-------------------------------------------------------------------------------------------------------------------------------------
-- delete unused columns !

select *
from  datacleaning..dataclean

alter table datacleaning.dbo.clean
drop column owneraddress,taxdistrict,propertyaddress,saledate














