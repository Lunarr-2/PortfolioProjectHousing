---verify data
Select * 
FROM NashvilleHousing



---date format
SELECT SaleDate
FROM NashvilleHousing


--1)
--- populate the PropertyAddress
Select *
FROM NashvilleHousing
---WHERE PropertyAddress is NULL
ORDER by ParcelID


---- first self join table to populate the PropertyAddress
Select a.ParcelID, a.PropertyAddress,  b.ParcelID,b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress) 
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
--check if the id's are different
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL





-- now update the COLUMN
UPDATE NashvilleHousing
SET PropertyAddress = (
    SELECT b.PropertyAddress
    FROM NashvilleHousing b
    WHERE b.ParcelID = NashvilleHousing.ParcelID
      AND b.UniqueID <> NashvilleHousing.UniqueID
      AND b.PropertyAddress IS NOT NULL
    LIMIT 1
)
WHERE PropertyAddress IS NULL;


--2)
-----Breaking out the addresss into individual columns (Address, city, state)
Select PropertyAddress,  PropertySplitAddress, PropertySplitCity
FROM NashvilleHousing

SELECT
 substr(PropertyAddress, 1, instr( PropertyAddress, ',') - 1 ) as Address,
 substr(PropertyAddress, instr( PropertyAddress, ',')  + 1 , length(PropertyAddress)) as Address

FROM NashvilleHousing



--add new column to the database hold data

ALTER TABLE NashvilleHousing
ADD  PropertySplitAddress TEXT;

UPDATE NashvilleHousing
SET  PropertySplitAddress = substr(PropertyAddress, 1, instr( PropertyAddress, ',') - 1 )


ALTER TABLE NashvilleHousing
ADD  PropertySplitCity TEXT;

UPDATE NashvilleHousing
SET PropertySplitCity = substr(PropertyAddress, instr( PropertyAddress, ',')  + 1 , length(PropertyAddress))


--3
--seperate the OwnerAddress as well
SELECT  OwnerAddress,
substr(OwnerAddress,1, instr(OwnerAddress, ',') - 1) as Address,
substr(OwnerAddress, instr(OwnerAddress, ',') + 1, length(OwnerAddress)) as Address,
substr(OwnerAddress, instr(OwnerAddress,',') + instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 1 ), ',')  + 1) as Address


FROM NashvilleHousing


--add  new splitted owner address column to the database

ALTER TABLE NashvilleHousing
ADD  OwnerSplitAddress TEXT;

UPDATE NashvilleHousing
SET  OwnerSplitAddress = substr(OwnerAddress,1, instr(OwnerAddress, ',') - 1)


ALTER TABLE NashvilleHousing
ADD  OwnerSplitCity TEXT;

UPDATE NashvilleHousing
SET OwnerSplitCity =substr(OwnerAddress, instr(OwnerAddress, ',') + 1, length(OwnerAddress)) 

ALTER TABLE NashvilleHousing
ADD  OwnerSplitState TEXT;

UPDATE NashvilleHousing
SET   OwnerSplitState  = substr(OwnerAddress, instr(OwnerAddress,',') + instr(substr(OwnerAddress, instr(OwnerAddress, ',') + 1 ), ',')  + 1)


SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
GROUP by SoldAsVacant
ORDER by 2 DESC


-----Change Y to Yes and N to No
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN  'Yes' 
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
from NashvilleHousing

------update database 
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes' 
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
		
		
		
		
------------Remove Duplicate
WITH RowNumCTE as (
SELECT *,
		row_number() OVER (
		PARTITION by ParcelID, 
										PropertyAddress,
										SalePrice,
										SaleDate,
										LegalReference
										ORDER by
											UniqueID
		) row_num
 FROM NashvilleHousing
--ORDER by ParcelID
)

SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER by ParcelID

----to actually remove them 
--SELECT *,
--		row_number() OVER (
--		PARTITION by ParcelID, 
--									PropertyAddress,
--										SalePrice,
--										SaleDate,
--									LegalReference
--										ORDER by
--											UniqueID
--		) row_num
-- FROM NashvilleHousing
--ORDER by ParcelID
--)

--DELETE 
 --FROM RowNumCTE
--WHERE row_num > 1


-------------Delete unused COLUMN
		
SELECT * 
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
DROP  COLUMN OwnerAddress, TaxDistrict, PropertyAddress

----select the house with the most price
SELECT UniqueID,max(SalePrice) as most_expensive
FROM NashvilleHousing