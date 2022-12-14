USE [master]
GO
/****** Object:  Database [QLBanHang]    Script Date: 8/19/2022 9:52:51 PM ******/
CREATE DATABASE [QLBanHang]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLBanHang', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLBanHang.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLBanHang_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLBanHang_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QLBanHang] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLBanHang].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLBanHang] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLBanHang] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLBanHang] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLBanHang] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLBanHang] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLBanHang] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QLBanHang] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLBanHang] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLBanHang] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLBanHang] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLBanHang] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLBanHang] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLBanHang] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLBanHang] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLBanHang] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLBanHang] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLBanHang] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLBanHang] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLBanHang] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLBanHang] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLBanHang] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLBanHang] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLBanHang] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QLBanHang] SET  MULTI_USER 
GO
ALTER DATABASE [QLBanHang] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLBanHang] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLBanHang] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLBanHang] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QLBanHang] SET DELAYED_DURABILITY = DISABLED 
GO
USE [QLBanHang]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_demSoSPxyz]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_demSoSPxyz](@x int, @y int,@tenH varchar(50))
returns int
as
begin
	declare @count int
	select @count=COUNT(MaSP)
						from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
						where Giaban>=@x and Giaban<=@y and TenHang=@tenH;
	return @count
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_sanPhamTheoGiaHang]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_sanPhamTheoGiaHang](@x int, @y int,@tenH varchar(50))
returns @SanPham1 table(MaSP varchar(20), TenSP varchar(50), SoLuong int, MauSac varchar(20), GiaBan int)
as
begin
	insert into @SanPham1 
		select MaSP,TenSP,SoLuong,MauSac,Giaban from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
						where Giaban>=@x and Giaban<=@y and TenHang=@tenH;
return
end;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_sanPhamTheoHang]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_sanPhamTheoHang](@tenH varchar(50), @chon int)
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
GO
/****** Object:  UserDefinedFunction [dbo].[fn_timTenHangTheoMaSP]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_timTenHangTheoMaSP](@MaSP varchar(20))
returns varchar(50)
as
begin
	Declare @tenH varchar(20)
	select @tenH=TenHang from sanpham INNER JOIN hangsx ON sanpham.MaHangSX=hangsx.MaHangSX
	where MaSP=@MaSP;
	return @tenH
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_tinhTongNhap]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_tinhTongNhap](@namX int, @namY int)
returns int
as
begin
	declare @tong int;
	select @tong= SUM(SoLuongN*DonGiaN)
	from nhap INNER JOIN pnhap ON nhap.SoHDN=pnhap.SoHDN
	where YEAR(NgayNhap)>=@namX and YEAR(NgayNhap)<=@namY

	return @tong
end;
GO
/****** Object:  Table [dbo].[hangsx]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hangsx](
	[MaHangSX] [varchar](20) NOT NULL,
	[TenHang] [varchar](20) NOT NULL,
	[DiaChi] [varchar](35) NULL DEFAULT (NULL),
	[SoDT] [varchar](20) NULL DEFAULT (NULL),
	[Email] [varchar](30) NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[MaHangSX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[hangsx2]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hangsx2](
	[MaHangSX] [varchar](20) NOT NULL,
	[TenHang] [varchar](20) NOT NULL,
	[DiaChi] [varchar](35) NULL DEFAULT (NULL),
	[SoDT] [varchar](20) NULL DEFAULT (NULL),
	[Email] [varchar](30) NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[MaHangSX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[nhanvien]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[nhanvien](
	[MaNV] [varchar](20) NOT NULL,
	[TenNV] [varchar](40) NOT NULL,
	[DiaChi] [varchar](45) NULL DEFAULT (NULL),
	[GioiTinh] [varchar](20) NULL DEFAULT (NULL),
	[SoDT] [varchar](45) NOT NULL,
	[Email] [varchar](45) NULL DEFAULT (NULL),
	[TenPhong] [varchar](45) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[nhap]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[nhap](
	[SoN] [varchar](20) NOT NULL,
	[SoHDN] [varchar](20) NOT NULL,
	[MaSP] [varchar](20) NOT NULL,
	[SoLuongN] [int] NULL DEFAULT (NULL),
	[DonGiaN] [varchar](45) NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[SoN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pnhap]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pnhap](
	[SoHDN] [varchar](20) NOT NULL,
	[NgayNhap] [datetime] NOT NULL,
	[MaNV] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SoHDN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pxuat]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pxuat](
	[SoHDX] [varchar](20) NOT NULL,
	[NgayXuat] [datetime] NULL DEFAULT (NULL),
	[MaNV] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SoHDX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sanpham]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sanpham](
	[MaSP] [varchar](20) NOT NULL,
	[MaHangSX] [varchar](20) NOT NULL,
	[TenSP] [varchar](40) NOT NULL,
	[SoLuong] [int] NULL DEFAULT (NULL),
	[MauSac] [varchar](45) NULL DEFAULT (NULL),
	[Giaban] [decimal](13, 2) NULL DEFAULT (NULL),
	[DonViTinh] [varchar](45) NULL DEFAULT (NULL),
	[MoTa] [varchar](1000) NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[xuat]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xuat](
	[SoX] [varchar](20) NOT NULL,
	[SoHDX] [varchar](20) NOT NULL,
	[MaSP] [varchar](20) NOT NULL,
	[SoLuongX] [int] NULL DEFAULT (NULL),
	[DonGiaX] [varchar](45) NULL,
PRIMARY KEY CLUSTERED 
(
	[SoX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_DSPN]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_DSPN]
as
select  TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
from nhap inner join sanpham on Nhap.MaSP=sanpham.MaSP
		inner join pnhap on nhap.SoHDN=pnhap.SoHDN
		inner join nhanvien on pnhap.MaNV=nhanvien.MaNV
		inner join hangsx on hangsx.MaHangSX=sanpham.MaHangSX
where TenHang='Samsung' and YEAR(NgayNhap)=2021
GO
/****** Object:  View [dbo].[vw_TTSP1]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_TTSP1]
as
select  MaSP, TenHang, TenSP, SoLuong, MauSac,Giaban,DonViTinh
from sanpham inner join hangsx on sanpham.MaHangSX=hangsx.MaHangSX
where TenHang='Samsung'
and Giaban>=1000000 and Giaban<=10000000;
GO
/****** Object:  View [dbo].[vw_vd1]    Script Date: 8/19/2022 9:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_vd1]
as
select nh.SoHDN,sp.TenSP, TenHang, SoLuongN, 
DonGiaN,NgayNhap, TenNV,TenPhong
from sanpham sp INNER JOIN nhap nh ON sp.MaSP=nh.MaSP
INNER JOIN pnhap pnh ON  nh.SoHDN=pnh.SoHDN
INNER JOIN nhanvien nv ON pnh.MaNV=nv.MaNV
INNER JOIN hangsx h ON h.MaHangSX=sp.MaHangSX
where TenHang='Samsung' and YEAR(NgayNhap)=2021
GO
ALTER TABLE [dbo].[nhap]  WITH CHECK ADD  CONSTRAINT [fk_hoadon_nhap] FOREIGN KEY([SoHDN])
REFERENCES [dbo].[pnhap] ([SoHDN])
GO
ALTER TABLE [dbo].[nhap] CHECK CONSTRAINT [fk_hoadon_nhap]
GO
ALTER TABLE [dbo].[nhap]  WITH CHECK ADD  CONSTRAINT [fk_sanpham_nhap] FOREIGN KEY([MaSP])
REFERENCES [dbo].[sanpham] ([MaSP])
GO
ALTER TABLE [dbo].[nhap] CHECK CONSTRAINT [fk_sanpham_nhap]
GO
ALTER TABLE [dbo].[pnhap]  WITH CHECK ADD  CONSTRAINT [fk_nhanvien_nhap] FOREIGN KEY([MaNV])
REFERENCES [dbo].[nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[pnhap] CHECK CONSTRAINT [fk_nhanvien_nhap]
GO
ALTER TABLE [dbo].[pxuat]  WITH CHECK ADD  CONSTRAINT [fk_nhanvien_xuat] FOREIGN KEY([MaNV])
REFERENCES [dbo].[nhanvien] ([MaNV])
GO
ALTER TABLE [dbo].[pxuat] CHECK CONSTRAINT [fk_nhanvien_xuat]
GO
ALTER TABLE [dbo].[sanpham]  WITH CHECK ADD  CONSTRAINT [fk_sanpham_sanxuat] FOREIGN KEY([MaHangSX])
REFERENCES [dbo].[hangsx] ([MaHangSX])
GO
ALTER TABLE [dbo].[sanpham] CHECK CONSTRAINT [fk_sanpham_sanxuat]
GO
ALTER TABLE [dbo].[xuat]  WITH CHECK ADD  CONSTRAINT [fk_hoadon_xuat] FOREIGN KEY([SoHDX])
REFERENCES [dbo].[pxuat] ([SoHDX])
GO
ALTER TABLE [dbo].[xuat] CHECK CONSTRAINT [fk_hoadon_xuat]
GO
ALTER TABLE [dbo].[xuat]  WITH CHECK ADD  CONSTRAINT [fk_sanpham_xuat] FOREIGN KEY([MaSP])
REFERENCES [dbo].[sanpham] ([MaSP])
GO
ALTER TABLE [dbo].[xuat] CHECK CONSTRAINT [fk_sanpham_xuat]
GO
ALTER TABLE [dbo].[sanpham]  WITH CHECK ADD  CONSTRAINT [ck_check] CHECK  (([SoLuong]>=(0)))
GO
ALTER TABLE [dbo].[sanpham] CHECK CONSTRAINT [ck_check]
GO
USE [master]
GO
ALTER DATABASE [QLBanHang] SET  READ_WRITE 
GO
