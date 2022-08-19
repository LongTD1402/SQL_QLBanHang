use QLBanHang
go

/*--SELECT DISTINCT : lọc các giá trị giống nhau*/
select distinct MaHangSX  /*đưa ra các mã hàng khác nhau có trong danh sách sản phẩm*/
from sanpham;

/*-- SELECT COUNT() :trả về số lượng bản ghi đc lọc theo 1 điều kiện */
select 'Số lượng SP'=count(TenSP)
from sanpham;
	/*--SELECT COUNT(DISTINCT ) :trả về số lượng các bản ghi khác nhau*/
	select 'Số lượng hãng'= count(distinct MaHangSX)
	from sanpham;
	/*--SELECT COUNT(*) : trả về số lượng bản ghi*/
	select 'Số lượng bản ghi'=count(*)
	from sanpham;

/*--SELECT TOP : trả về số lượng bản ghi đầu tiên theo chỉ định*/
select top 3 *   /*trả về 3 bản ghi đầu tiên của bảng sanpham*/
from sanpham;
	/*--SELECT TOP ... PERCENT : trả về % số lượng bản ghi theo chỉ định*/
	select top 30 percent *
	from sanpham;
	
/*--SELECT IN :giúp giảm thiểu việc sử dụng toán tử OR*/
select *from sanpham;
select * from sanpham where TenSP IN('Dien Thoai','Tai nghe');

/*--SELECT DATE : */


/*-- SELECT SUM() : trả về tổng của 1 biểu thức*/
select SUM(Giaban) as 'Tổng giá'
from sanpham
where Giaban>=15000;
	/*--SELECT SUM() .. GROUP BY...*/
	select TenSP,SUM(Giaban) as 'Tổng giá'
	from sanpham
	where Giaban>=15000
	group by TenSp;


/*-- SELECT NULL : ...is null hoặc ...is not null*/


/*---phép hợp: UNION----*/
create table hangsx2(
  MaHangSX varchar(20) NOT NULL,
  TenHang varchar(20) NOT NULL,
  DiaChi varchar(35)  DEFAULT NULL,
  SoDT varchar(20) DEFAULT NULL,
  Email varchar(30) DEFAULT NULL,
  PRIMARY KEY (MaHangSX)
);
/*--UPDATE--: cập nhật dữ liệu các bản ghi trong bảng*/

select*from sanpham;
update sanpham
set MauSac='Vang'
where MauSac='Tim';
INSERT INTO hangsx2 VALUES 
('MH004','Xaomi','Hanoi','0393458433','xaomi@example.com'),
('MH005','Nokia','DaNang','098384773','nokia@example.com');
select * from hangsx
UNION ALL
select * from hangsx2;

/*-- nối 2 bảng---*/

 /*Đưa ra tên sản phẩm, màu sắc, số lượng, tên hãng của tất cả cá sản phẩm*/
select 'Tên SP'=TenSP,'Màu sắc'=MauSac,'Số lượng'=SoLuong,'Tên hãng'=TenHang
from sanpham, hangsx
where sanpham.MaHangSX=hangsx.MaHangSX;

/*Phép nối trong -- INNER JOIN : trả về các giá trị có ở cả hai bảng được nối*/

	/*--2 bảng*/
select 'Tên SP'=TenSP,'Màu sắc'=MauSac,'Số lượng'=SoLuong,'Tên hãng'=TenHang
from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX;
	/*--nhiều bảng*/
select 'Tên SP'=TenSP, 'Số lượng xuất'=SoLuongX, 'Ngày xuất'=NgayXuat
from sanpham INNER JOIN xuat ON sanpham.MaSP=xuat.MaSP
INNER JOIN pxuat ON xuat.SoHDX=pxuat.SoHDX;

/*-- LEFT JOIN: trả về các bản ghi của bảng bên trái và các bản ghi tương ứng ở bảng bên phải 
	(nếu không có giá trị thì trả về null)*/
select*from sanpham;
select*from hangsx;

select 'Tên SP'=TenSP,'Màu sắc'=MauSac,'Số lượng'=SoLuong,'Tên hãng'=TenHang
from hangsx LEFT JOIN sanpham ON hangsx.MaHangSX=sanpham.MaHangSX;   
	/*--==>những hãng chưa có sản phẩm nào sẽ có các cột(tên sp, màu sắc, số lượng)có giá trị null*/

/*-- RIGHT JOIN:trả về các bản ghi của bảng bên phải và các bản ghi tương ứng ở bảng bên trái 
	(nếu không có giá trị thì trả về null)*/
select 'Tên SP'=TenSP,'Màu sắc'=MauSac,'Số lượng'=SoLuong,'Tên hãng'=TenHang
from sanpham RIGHT JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX;

/*FULL OUTER JOIN: trả về tất cả các bảng ghi có trong 2 bảng được nối*/
select 'Tên SP'=TenSP,'Màu sắc'=MauSac,'Số lượng'=SoLuong,'Tên hãng'=TenHang
from sanpham FULL OUTER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX;

/*SELT JOIN : trả về các bản ghi có 1 hoặc nhiều trường giống nhau trong 1 bảng*/
select a.TenSP, a.MaHangSX,b.TenSP,b.MaHangSX
from sanpham a, sanpham b
where a.TenSP=b.TenSP and a.MaHangSX<>b.MaHangSX;

/*Thống kê dữ liệu với Group by: được sử dụng để tổ chức dữ liệu tương tự thành các nhóm. 
	Dữ liệu được tổ chức thêm với sự trợ giúp của chức năng tương đương. Nó có nghĩa là,
	nếu các hàng khác nhau trong một cột chính xác có cùng giá trị, 
	nó sẽ sắp xếp các hàng đó thành một nhóm.*/
select * from sanpham;
select * from hangsx;

	/*Đưa ra tổng giá các loại hàng của từng hãng*/
	select TenSP,TenHang,SUM(Giaban*SoLuong/1000) as 'Tổng giá'
	from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
	where Giaban>=15000
	group by TenSp,TenHang;

/*Sắp xếp dữ liệu với ORDER BY*/


/*--VD1:Đưa ra thông tin MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh, 
MoTa của các sản phẩm sắp xếp theo chiều giảm dần giá bán.*/
select 'Mã SP'=MaSP,'Tên SP'=TenSP,'Tên hãng'=TenHang,'Số lượng'=SoLuong,
'Màu Sắc'=MauSac,'Giá bán'=Giaban,'ĐVT'=DonViTinh
from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
ORDER BY Giaban DESC;

/*--VD2:Đưa ra thông tin các sản phẩm có trong cữa hàng do công ty 
có tên hãng là Samsung sản xuất*/
select * from sanpham INNER JOIN hangsx
ON sanpham.MaHangSX=hangsx.MaHangSX
where TenHang='Samsung';

/*--VD3:Đưa ra thông tin các nhân viên Nữ ở phòng ‘Kế toán’.*/
select *from nhanvien
where TenPhong='Ke toan' and GioiTinh='Nu';

/*--VD4:Đưa ra thông tin phiếu nhập gồm: SoHDN, MaSP, TenSP, TenHang, SoLuongN, 
DonGiaN, TienNhap=SoLuongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV, 
TenPhong, sắp xếp theo chiều tăng dần của hóa đơn nhập.*/

select nh.SoHDN,sp.TenSP, TenHang, SoLuongN, 
DonGiaN, 'TienNhap'=SoLuongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV, 
TenPhong
from sanpham sp INNER JOIN nhap nh ON sp.MaSP=nh.MaSP
INNER JOIN pnhap pnh ON  nh.SoHDN=pnh.SoHDN
INNER JOIN nhanvien nv ON pnh.MaNV=nv.MaNV
INNER JOIN hangsx h ON h.MaHangSX=sp.MaHangSX
ORDER BY nh.SoHDN ASC;

/*--VD5:Đưa ra thông tin phiếu xuất gồm: SoHDX, MaSP, TenSP, TenHang, SoLuongX, 
GiaBan, tienxuat=SoLuongX*GiaBan, MauSac, DonViTinh, NgayXuat, TenNV, 
TenPhong trong tháng 06 năm 2020, sắp xếp theo chiều tăng dần của SoHDX.*/
Alter table xuat
add DonGiaX varchar(45);

select xu.SoHDX,sp.TenSP, TenHang, SoLuongX, 
DonGiaX, 'TienNhap'=SoLuongX*DonGiaX, MauSac, DonViTinh, NgayXuat, TenNV, 
TenPhong
from sanpham sp INNER JOIN xuat xu ON sp.MaSP=xu.MaSP
INNER JOIN pxuat px ON  xu.SoHDX=px.SoHDX
INNER JOIN nhanvien nv ON px.MaNV=nv.MaNV
INNER JOIN hangsx h ON h.MaHangSX=sp.MaHangSX
ORDER BY xu.SoHDX ASC;

/*--VD6:Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập
 trong năm 2021, gồm: 
SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.*/

select nh.SoHDN,sp.TenSP, TenHang, SoLuongN, 
DonGiaN,NgayNhap, TenNV,TenPhong
from sanpham sp INNER JOIN nhap nh ON sp.MaSP=nh.MaSP
INNER JOIN pnhap pnh ON  nh.SoHDN=pnh.SoHDN
INNER JOIN nhanvien nv ON pnh.MaNV=nv.MaNV
INNER JOIN hangsx h ON h.MaHangSX=sp.MaHangSX
where TenHang='Samsung' and YEAR(NgayNhap)=2021
ORDER BY nh.SoHDN ASC;

/*--VD7: . Đưa ra Top 3 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2022, sắp xếp theo 
chiều giảm dần của SoLuongX. */

select TOP 3 xuat.SoHDX,NgayXuat,'Số lượng'=SUM(SoLuongX)
from xuat INNER JOIN pxuat ON xuat.SoHDX=pxuat.SoHDX
where YEAR(NgayXuat)=2022
Group by xuat.SoHDX,NgayXuat
order by SUM(SoLuongX) DESC;

/*--VD8: Đưa ra thông tin 3 sản phẩm có giá bán cao nhất trong cữa hàng, 
theo chiều giảm dần giá bán.*/
select top 3 *from sanpham
order by Giaban desc;

/*--VD9: Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 
của hãng Samsung. */
select * from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
where TenHang='Samsung' and Giaban>100000 and Giaban<500000;

/*--VD10:Tính tổng tiền đã nhập trong năm 2021 của hãng Samsung*/
select 'Tổng tiền nhập'=SUM(SoLuongN*DonGiaN)
from nhap   INNER JOIN sanpham ON nhap.MaSP=sanpham.MaSP
			INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
			INNER JOIN pnhap ON pnhap.SoHDN=nhap.SoHDN
where TenHang='Samsung' and YEAR(NgayNhap)=2021

/*--VD11: Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020.*/
select top 1 pnhap.SoHDN,NgayNhap,'Tổng tiền nhập'=SUM(SoLuongN*DonGiaN)
from nhap   INNER JOIN sanpham ON nhap.MaSP=sanpham.MaSP
			INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
			INNER JOIN pnhap ON pnhap.SoHDN=nhap.SoHDN
where YEAR(NgayNhap)=2021
group by pnhap.SoHDN,NgayNhap
order by SUM(SoLuongN*DonGiaN) DESC;
/*hoặc:*/
Select Nhap.SoHDN,NgayNhap,'Tổng tiền nhập'=SoLuongN*DonGiaN
From Nhap Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
Where Year(NgayNhap)=2021 And SoLuongN*DonGiaN =
												 (Select Max(SoLuongN*DonGiaN)
												 From Nhap Inner join PNhap on 
												Nhap.SoHDN=PNhap.SoHDN
												 Where Year(NgayNhap)=2021
												 )

/*--VD12: Thống kê xem mỗi hãng có bao nhiêu loại sản phẩm*/
select TenHang, 'Số loại sản phẩm'=COUNT(*)
from hangsx INNER JOIN sanpham ON hangsx.MaHangSX=sanpham.MaHangSX
Group by TenHang

/*--VD13: Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2021.*/
select *from sanpham;
select TenSP,'Tổng tiền nhập'=SUM(DonGiaN*SoLuongN)
from sanpham LEFT JOIN nhap ON sanpham.MaSP=nhap.MaSP
group by TenSP

/*--VD14: Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn
 10 sản phẩm của hãng Samsung.*/
select TenSP ,'Tổng số lượng xuất:'=SUM(SoLuongX)
from sanpham INNER JOIN xuat ON sanpham.MaSP=xuat.MaSP
INNER JOIN hangsx ON hangsx.MaHangSX=sanpham.MaHangSX
where TenHang='Samsung' 
Group by TenSP
having SUM(SoLuongX)>10;

/*--VD15: Thống kê số lượng nhân viên nam của mỗi phòng ban*/
select* from nhanvien;
select TenPhong, 'Số lượng nv nam'=COUNT(*)
from nhanvien 
where GioiTinh='Nam'
Group by TenPhong;

/*--VD16: Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2021.*/
select hangsx.TenHang,'Tổng số lượng nhập'=sum(SoLuongN)
from nhap INNER JOIN sanpham on nhap.MaSP=sanpham.MaSP
inner join hangsx on sanpham.MaHangSX=hangsx.MaHangSX
inner join pnhap on nhap.SoHDN=pnhap.SoHDN
where YEAR(NgayNhap)=2021
Group by hangsx.TenHang;

/*--VD17: Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2022 
là bao nhiêu.*/
select nhanvien.TenNV,'Tổng tiền xuất'=SUM(DonGiaX*SoLuongX) 
from nhanvien INNER JOIN pxuat ON nhanvien.MaNV=pxuat.MaNV
INNER JOIN xuat ON pxuat.SoHDX=xuat.SoHDX
where YEAR(NgayXuat)=2022 
Group by nhanvien.TenNV

/*--VD18:  Hãy Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.*/
select *from sanpham;
select *from nhap;
select *from xuat;
select TenSP,MaHangSX
from sanpham INNER JOIN nhap ON sanpham.MaSP=nhap.MaSP
where sanpham.MaSP not in (select xuat.MaSP from xuat);

/*--VD19:Đưa ra danh sách các nhân viên vừa nhập vừa xuất.*/
select distinct nhanvien.MaNV ,TenNV
from nhanvien INNER JOIN pnhap ON nhanvien.MaNV=pnhap.MaNV 
where nhanvien.MaNV in (select pxuat.MaNV from pxuat);

/*--VD20: Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất*/
select nhanvien.MaNV
from nhanvien
where nhanvien.MaNV not in (select pxuat.MaNV from pxuat 
							UNION  select pnhap.MaNV from pnhap );

/*--View- Khung nhìn: */


