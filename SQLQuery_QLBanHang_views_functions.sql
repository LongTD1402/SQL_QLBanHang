use QLBanHang
go

/*--VIEW - KHUNG NHÌN:Là bảng ảo, Được tạo ra từ câu truy vấn, dữ liệu trong view 
sẽ đuwọc update theo dữ liệu các bảng bàn view truy vấn tới */
/*--vd1:. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 20210, 
gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.*/

create view vw_vd1
as
select nh.SoHDN,sp.TenSP, TenHang, SoLuongN, 
DonGiaN,NgayNhap, TenNV,TenPhong
from sanpham sp INNER JOIN nhap nh ON sp.MaSP=nh.MaSP
INNER JOIN pnhap pnh ON  nh.SoHDN=pnh.SoHDN
INNER JOIN nhanvien nv ON pnh.MaNV=nv.MaNV
INNER JOIN hangsx h ON h.MaHangSX=sp.MaHangSX
where TenHang='Samsung' and YEAR(NgayNhap)=2021

select *from vw_vd1;

/*-- CHECK: cách sử dụng như các khóa cảu bảng*/
alter table sanpham add constraint ck_check
CHECK (SoLuong>=0);

/*--Function*/
	/*--Scalar valued function*/
	/*--VD2:Hãy xây dựng hàm Đưa ra tên hãng sản xuất khi nhập vào MaSP từ bàn phím*/
create function fn_timTenHangTheoMaSP(@MaSP varchar(20))
returns varchar(50)
as
begin
	Declare @tenH varchar(20)
	select @tenH=TenHang from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
	where MaSP=@MaSP;
	return @tenH
end
select dbo.fn_timTenHangTheoMaSP('SP001') as 'Tên hãng';


	/*--vd3:Hãy xây dựng hàm đếm số sản phẩm có giá bán từ x đến y do hãng z cung ứng, 
	với x,y,z nhập từ bàn phím.*/
create function fn_demSoSPxyz(@x int, @y int,@tenH varchar(50))
returns int
as
begin
	declare @count int
	select @count=COUNT(MaSP)
						from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
						where Giaban>=@x and Giaban<=@y and TenHang=@tenH;
	return @count
end;
select dbo.fn_demSoSPxyz(0,10000000,'Samsung') as 'Số lượng';

/*--VD4: Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, 
với x, y được nhập vào từ bàn phím.*/
create function fn_tinhTongNhap(@namX int, @namY int)
returns int
as
begin
	declare @tong int;
	select @tong= SUM(SoLuongN*DonGiaN)
		from nhap INNER JOIN pnhap ON nhap.SoHDN=pnhap.SoHDN
		where YEAR(NgayNhap)>=@namX and YEAR(NgayNhap)<=@namY

	return @tong
end;
select dbo.fn_tinhTongNhap(2020,2022) as 'Tổng nhập'

/*-- Table valued function*/
	/*--vd5:Hãy tạo hàm đưa ra thông tin các sản phẩm có giá bán >=x và do hãng y cung ứng.
	Với x,y nhập từ bàn phím.*/
create function fn_sanPhamTheoGiaHang(@x int, @y int,@tenH varchar(50))
returns @SanPham1 table(MaSP varchar(20), TenSP varchar(50), SoLuong int, MauSac varchar(20), GiaBan int)
as
begin
	insert into @SanPham1 
		select MaSP,TenSP,SoLuong,MauSac,Giaban from sanpham INNER JOIN hangsx 
						ON sanpham.MaHangSX=hangsx.MaHangSX
		where Giaban>=@x and Giaban<=@y and TenHang=@tenH;
return
end;
select *from fn_sanPhamTheoGiaHang(0,10000000,'Samsung');

	/*--VD6:Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, 
nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong <50, ngược lại lựa chọn 
=1 thì Đưa ra danh sách các sản phẩm có SoLuong >=50. */
create function fn_sanPhamTheoHang(@tenH varchar(50), @chon int)
Returns @bang Table (MaSP nvarchar(10), TenSP nvarchar(20),TenHang nvarchar(20), 
SoLuong int, MauSac nvarchar(20), GiaBan money, DonViTinh nvarchar(10), MoTa nvarchar(max))
As
Begin
 If(@chon=0)
	 Insert Into @bang 
		 Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
		 From SanPham Inner join HangSX 
		 on SanPham.MaHangSX = HangSX.MaHangSX 
		 Where TenHang = @tenH And SoLuong<50
 Else 
	 If(@chon =1)
	 Insert Into @bang 
		 Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
		 From SanPham Inner join HangSX 
		 on SanPham.MaHangSX = HangSX.MaHangSX 
		 Where TenHang = @tenH And SoLuong >=50
 Return
End
select * from fn_sanPhamTheoHang('Apple',0);



