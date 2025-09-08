--Cleaning Data with SQL Queries

select *
from [PORTFOLIO PROJECT].dbo.[Housing Data]


--Standardize Date Format in SaleDate

select SaleDate, convert(date,SaleDate)    -- to view how would column look if created
from [PORTFOLIO PROJECT].dbo.[Housing Data]

update [Housing Data]       --converted the data 
set SaleDate = convert(Date,SaleDate)

alter table [Housing Data]
add SaleDateConverted Date;    --created the new column

update [Housing Data]
set SaleDateConverted = convert(date,SaleDate)    -- assigning the value into the new column


select SaleDateConverted, convert(date,SaleDate)   -- for viewing the new column 
from [PORTFOLIO PROJECT].dbo.[Housing Data]



---Populate the Property Address Data

select *
from [PORTFOLIO PROJECT].dbo.[Housing Data]
--where PropertyAddress is null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT]..[Housing Data] a
join [PORTFOLIO PROJECT]..[Housing Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a  
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT]..[Housing Data] a
join [PORTFOLIO PROJECT]..[Housing Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is not null			


--Breaking the Address column individual (Address,City,State)

select PropertyAddress
from [PORTFOLIO PROJECT].dbo.[Housing Data]

select 
	SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) -1) as Address
	,SUBSTRING(PropertyAddress,charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from [PORTFOLIO PROJECT].dbo.[Housing Data]


alter table [PORTFOLIO PROJECT].dbo.[Housing Data]
add SplitAddress nvarchar(255);

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set SplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) -1)

alter table [PORTFOLIO PROJECT].dbo.[Housing Data]
add SplitAddressCity nvarchar(255);

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set SplitAddressCity = SUBSTRING(PropertyAddress,charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from [PORTFOLIO PROJECT].dbo.[Housing Data]

--Splitting Owner Address as done above, but with easier method

select  OwnerAddress
from [PORTFOLIO PROJECT].dbo.[Housing Data]


select 
parsename(replace(OwnerAddress,',','.'),3)
,parsename(replace(OwnerAddress,',','.'),2)
,parsename(replace(OwnerAddress,',','.'),1)
from [PORTFOLIO PROJECT].dbo.[Housing Data]


alter table [PORTFOLIO PROJECT].dbo.[Housing Data]
add OwnerSplitAddress nvarchar(255);

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set OwnerSplitAddress  = parsename(replace(OwnerAddress,',','.'),3)

alter table [PORTFOLIO PROJECT].dbo.[Housing Data]
add OwnerSplitCity  nvarchar(255);

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set OwnerSplitCity  = parsename(replace(OwnerAddress,',','.'),2)


alter table [PORTFOLIO PROJECT].dbo.[Housing Data]
add OwnerSplitState  nvarchar(255);

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set OwnerSplitState  = parsename(replace(OwnerAddress,',','.'),1)



select  *
from [PORTFOLIO PROJECT].dbo.[Housing Data]


--Replacing Y and N to Yes & No in SoldAsVacant

select  distinct(SoldAsVacant), count(SoldAsVacant)
from [PORTFOLIO PROJECT].dbo.[Housing Data]

group by SoldAsVacant
order by 2



select  SoldAsVacant
,case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 
from [PORTFOLIO PROJECT].dbo.[Housing Data]

update [PORTFOLIO PROJECT].dbo.[Housing Data]
set SoldAsVacant = case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 


select  distinct(SoldAsVacant), count(SoldAsVacant)
from [PORTFOLIO PROJECT].dbo.[Housing Data]
group by SoldAsVacant
order by 2     -----   to see the updated data



--Removing the Duplicates that are present in the data

with RowNumCTE as(
select *,
	ROW_NUMBER() OVER(
	partition by ParcelID,
				 PropertyAdress,
				 SalePrice,
				 SaleAddress,
				 LegalReference
				 order by
				 UniqueID
				 )row_num

from [PORTFOLIO PROJECT].dbo.[Housing Data]

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress




-- DELETE THE UNNECESSARY COLUMNS 
select *
from [PORTFOLIO PROJECT]..[Housing Data]

alter table [PORTFOLIO PROJECT]..[Housing Data]
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [PORTFOLIO PROJECT]..[Housing Data]
drop column SaleDate
  


