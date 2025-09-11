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
Select PropertyAddress
FROM NashvilleHousing

SELECT
 substr(PropertyAddress, 1, instr( PropertyAddress, ',') - 1 ) as Address

FROM NashvilleHousing


----select the house with the most price
SELECT UniqueID,max(SalePrice) as most_expensive
FROM NashvilleHousing