CREATE DATABASE IF NOT EXISTS QuanLyBanHang;

USE QuanLyBanHang;

DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;


-- =========================
-- 1. TẠO BẢNG CUSTOMER
-- =========================

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);


-- =========================
-- 2. TẠO BẢNG ORDER
-- =========================

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);


-- =========================
-- 3. TẠO BẢNG PRODUCT
-- =========================

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);


-- =========================
-- 4. TẠO BẢNG ORDERDETAIL
-- =========================

CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);


-- =========================
-- 5. THÊM DỮ LIỆU CUSTOMER
-- =========================

INSERT INTO Customer (cID, Name, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);


-- =========================
-- 6. THÊM DỮ LIỆU ORDER
-- =========================

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);


-- =========================
-- 7. THÊM DỮ LIỆU PRODUCT
-- =========================

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);


-- =========================
-- 8. THÊM DỮ LIỆU ORDERDETAIL
-- =========================

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(2, 3, 8),
(2, 5, 4),
(3, 2, 3);


-- =====================================================
-- 9. HIỂN THỊ oID, oDate, oTotalPrice CỦA TẤT CẢ HÓA ĐƠN
-- =====================================================

SELECT 
    oID,
    oDate,
    oTotalPrice
FROM `Order`;


-- =====================================================
-- 10. HIỂN THỊ KHÁCH HÀNG ĐÃ MUA HÀNG
--     VÀ SẢN PHẨM ĐƯỢC MUA
-- =====================================================

SELECT 
    c.Name AS CustomerName,
    p.pName AS ProductName
FROM Customer c
JOIN `Order` o 
    ON c.cID = o.cID
JOIN OrderDetail od 
    ON o.oID = od.oID
JOIN Product p 
    ON od.pID = p.pID;


-- =====================================================
-- 11. HIỂN THỊ KHÁCH HÀNG KHÔNG MUA BẤT KỲ SẢN PHẨM NÀO
-- =====================================================

SELECT 
    c.cID,
    c.Name,
    c.cAge
FROM Customer c
LEFT JOIN `Order` o 
    ON c.cID = o.cID
WHERE o.oID IS NULL;


-- =====================================================
-- 12. TÍNH GIÁ TỪNG HÓA ĐƠN
--
-- Giá từng loại sản phẩm = odQTY * pPrice
-- Tổng tiền hóa đơn = SUM(odQTY * pPrice)
-- =====================================================

SELECT 
    o.oID,
    o.oDate,
    SUM(od.odQTY * p.pPrice) AS oPrice
FROM `Order` o
JOIN OrderDetail od 
    ON o.oID = od.oID
JOIN Product p 
    ON od.pID = p.pID
GROUP BY 
    o.oID,
    o.oDate;


-- =====================================================
-- 13. CẬP NHẬT TỔNG TIỀN VÀO oTotalPrice
-- =====================================================

UPDATE `Order` o
JOIN (
    SELECT 
        od.oID,
        SUM(od.odQTY * p.pPrice) AS total
    FROM OrderDetail od
    JOIN Product p 
        ON od.pID = p.pID
    GROUP BY od.oID
) AS temp
ON o.oID = temp.oID
SET o.oTotalPrice = temp.total;


-- =====================================================
-- 14. KIỂM TRA LẠI HÓA ĐƠN SAU KHI CẬP NHẬT
-- =====================================================

SELECT 
    oID,
    oDate,
    oTotalPrice
FROM `Order`
ORDER BY oID;


-- =====================================================
-- 15. HIỂN THỊ CHI TIẾT HÓA ĐƠN
-- =====================================================

SELECT
    o.oID,
    o.oDate,
    c.Name AS CustomerName,
    p.pName AS ProductName,
    od.odQTY AS Quantity,
    p.pPrice AS UnitPrice,
    od.odQTY * p.pPrice AS TotalPrice
FROM `Order` o
JOIN Customer c
    ON o.cID = c.cID
JOIN OrderDetail od
    ON o.oID = od.oID
JOIN Product p
    ON od.pID = p.pID
ORDER BY o.oID;


-- =====================================================
-- 16. HIỂN THỊ ĐẦY ĐỦ THÔNG TIN 4 BẢNG
-- =====================================================

SELECT * FROM Customer;

SELECT * FROM `Order`;

SELECT * FROM Product;

SELECT * FROM OrderDetail;