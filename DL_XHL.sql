create database VLXD_XHL
use VLXD_XHL
drop database VLXD_XHL
Create table NGUOIBAN
(
MaNB varchar(10) constraint PK_NGUOIBAN Primary Key,
TenNB nvarchar(50),
SDTNB varchar(10),
DchiNB nvarchar(100),
MathueNB varchar(20),
STKNB varchar (20)
)
go
Create table KHACHHANG
(
MaKH varchar(10) constraint PK_KHACHHANG Primary Key,
TenKH nvarchar(50),
SDTKH varchar(10),
DchiKH nvarchar(100),
MathueKH varchar(20),
STKKH varchar (20)
)
go
Create table SANPHAM
(
MaSP varchar(10) constraint PK_SANPHAM primary key,
TenSP nvarchar(100),
GiaSP int,
GiaVon int,
SLTon int,
DVT nvarchar(10)
)
go

create table HOADON
(
MaHD varchar(10) constraint PK_HOADON primary key,
NgayLap date,
TongTien numeric(20,0),
HinhthucTT nvarchar(20),
MaNB varchar(10),
MaKH varchar(10),
Constraint FK_NB FOREIGN KEY (MaNB) references NGUOIBAN(MaNB),
Constraint FK_KH FOREIGN KEY (MaKH) references KHACHHANG(MaKH)
)
go
Create table CHITIETHOADON
(
MaCT varchar(10) constraint PK_ChiTietHD primary key,
MaSP varchar(10),
MaHD varchar(10),
SoLuong int,
ThanhTien int,
DVT nvarchar(10),
DonGia int,
Constraint FK_maSP foreign key (Masp) references SANPHAM(MaSP),
Constraint FK_Mahd foreign key (MaHD) references HOADON(MaHD)
)

go

go
Create table TAIKHOAN
(
	TenDN varchar(200),
	Matkhau varchar(200),
	MaNB varchar(10),
	Quyen varchar(10),
	Constraint FK_Manb foreign key (MaNB) references NGUOIBAN(MaNB)
)

drop table Taikhoan
delete Taikhoan
--Mã hóa một chiều
UPDATE TAIKHOAN
SET Matkhau=CONVERT(VARCHAR(50),HASHBYTES ('SHA2_256',Matkhau),1)
select * from taikhoan
-- Mã hóa đối xứng bằng passphrase trên cột MATKHAU trong bảng NGUOIBAN
go
UPDATE TAIKHOAN SET Matkhau=EncryptByPassphrase('12345',Matkhau)
-- Giải mã đối xứng
UPDATE TAIKHOAN SET Matkhau=CONVERT(VARCHAR,DECRYPTBYPASSPHRASE('12345',Matkhau))
go

create or alter trigger ttaikhoan
on TAIKHOAN
after insert 
as
begin
	declare @matkhau varchar(200), @tendn varchar(200)
	select @matkhau= Matkhau, @tendn=TenDN from inserted
	UPDATE TAIKHOAN set Matkhau=EncryptByPassphrase('12345',@matkhau) where TenDN=@tendn 
end

insert into TAIKHOAN values ('nguoichu','123456','00','Admin')
insert into TAIKHOAN values ('nguoiphu1','1212','01','User')
insert into TAIKHOAN values ('nguoiphu2','2121','02','User')

go
create or alter function fhoadon()
returns varchar(10)
as
begin
	declare @mamoi varchar(10)
	select @mamoi=cast(max(cast(MaHD as numeric(10,0)))+1 as numeric (10,0)) from HOADON
	return @mamoi
end
create or alter function fchitiethoadon()
returns varchar(10)
as
begin
	declare @mamoi varchar(10)
	select @mamoi=cast (max(cast(MaCT as numeric(10,0)))+1 as numeric (10,0)) from CHITIETHOADON
	return @mamoi
end
select dbo.fchitiethoadon()
select *from chitiethoadon

select * from HOADON where mahd='200015'
select dbo.fhoadon()

select *  from taikhoan

insert into NGUOIBAN( MANB,TenNB,SDTNB,DchiNB,MathueNB,STKNB)values 
('00',N'Lê Thị Thu Thuỷ','0905723797',N'224 Dũng Sĩ Thanh Khê, Phường Thanh Khê Tây ,Quân Thanh Khê, Thành phố Đà Nẵng','0401554393','682888888668'),
('01',N'Phạm Bảo Trâm','0905556677',N'81 Núi Thành ,Phường Hoà Thuận, Quận Hải CHâu ,Thành phố Đà Nẵng','0801987654','987654321245'),
('02',N'Đỗ Minh Quân','0908123456',N'25 Trưng Nữ Vương, Phường Bình Thuận, Quận Hải Châu,Thành Phố Đà Nẵng','0935799215','102000606333')



insert into SANPHAM(MaSP, TenSP, GiaSP, GiaVon, SLTon, DVT)  values 
('XM001', N'Xi măng', 80000, 70000, 100, N'bao'),
('G002', N'Gạch', 780, 570, 1000, N'viên'),
('B003', N'Búa', 55000, 48000, 80, N'cái'),
('D004', N'Đèn tuýp M38 Rạng Đông', 220000, 180000, 120, N'cái'),
('D005',N'Đèn tuýp M18 Rạng Đông', 420000, 400000, 100, N'cái'),
('TC006', N'Thép cây phi 6', 15000, 13000, 200, N'kg'),
('TD007', N'Thép dây ', 30000, 27000, 100, N'kg'),
('MX008', N'Măng xô', 12000, 10000, 30, N'cái'),
('XM009', N'Sơn Dulux', 200000, 180000, 80, N'thùng'),
('C016', N'Sơn Nippon', 185000, 170000, 50, N'thùng'),
('Đ010', N'Đinh', 20000, 18000, 100, N'hộp'),
('XM011', N'Dây điện', 15000, 13000, 200, N'mét'),
('OD021', N'Ổ điện', 80000, 73000, 50, N'cái'),
('G012', N'Xẻng', 60000,55000, 50, N'cái'),
('N013', N'Ống nhựa PVC 27', 15000, 12000, 100, N'mét'),
('N014', N'Ống nhựa PVC 34', 10000, 8000, 100, N'mét'),
('C015', N'Máy khoan', 300000, 270000, 20,N'cái'),
('K016', N'Kiềm', 30000, 27000, 30, N'cái'),
('V017', N'Vữa', 150000, 120000, 50, N'thùng'),
('TV018', N'Tua vít', 20000, 18000, 30, N'cái'),
('GN019', N'Giấy nhám', 5000,4000, 100, N'miếng'),
('LX020', N'Cây lăn sơn', 40000,37000, 30, N'cái'),
('DM022', N'Đèn màu', 30000, 25000,30, N'dây'),
('Q023', N'Quạt', 200000, 170000, 50, N'cái'),
('MB024', N'Máy bơm', 230000, 200000, 20, N'cái'),
('ON025', N'Ống nước', 40000, 36000, 50, N'cái')
go

insert into KHACHHANG(MaKH,TenKH,SDTKH,DchiKH,MathueKH,STKKH)
values
('001',N'Phạm Thị Sương','0780301911',N'Bình Sơn, Quảng Ngãi',null,'00102900738'),
('002',N'Trần Trương Nhật Huy','0948927522',N'Mộ Đức, Quảng Ngãi','0123325438','100100099199'),
('003',N'Lê Thị Phương Yến','0375030115',N'Liên Chiểu,Đà Nẵng',null,'10010066778'),
('004',N'Bùi Lê Khánh Vy','0978889086',N'Ngũ Hành Sơn,Đà Nẵng',null,'10166191'),
('005',N'Nguyễn Vũ Nguyên Khang','0948921352',N'Sơn Trà,Đà Nẵng',null,'1011738823'),
('006',N'Trần Thị Phương Anh','0397363189',N'Núi Thành,Quảng Nam','0948573857','005894294'),
('007',N'Nguyễn Lan Phương','0938234744',N'Sơn Tịnh,Quảng Ngãi','9485903948','812749047113'),
('008',N'Lê Thị Thúy Quỳnh','0948974363',N'Tam Kỳ,Quảng Nam',null,'100100089234'),
('009',N'Mai Thành Đạt','0988482692',N'Ba Tơ,Quảng Ngãi',null,'005577911'),
('010',N'Lê Thiện Nhân','0327030110',N'Núi Thành,Quảng Nam',null,'100100099000'),
('011',N'Nguyễn Thị Tài','0375849490',N'Phan Tứ,Đà Nẵng',null,'10010004686'),
('012',N'Trần Thị Lý','0375473839',N'Ông Ích Khiêm,Đà Nẵng','0999849388','00058475859'),
('013',N'Nguyễn Ái Hoa','0378940937',N'Liên Chiểu,Đà Nẵng','0293847588','10935746686'),
('014',N'Nguyễn Quỳnh Như','0375756839',N'Quamg Trung,Đà Nẵng','0909473677','10010474886'),
('015',N'Bùi Lê Diệu Thúy','0375737490',N'Châu Thị Vĩnh Tế,Đà Nẵng',null,'100137184786'),
('016',N'Bùi Nhật Hà','0375847658',N'Mai Thúc Lân,Đà Nẵng',null,'1001000438486'),
('017',N'Nguyễn Linh Chi','0375843748',N'Nguyễn Văn Thoại,Đà Nẵng',null,'4657804686'),
('018',N'Nguyễn Nhật Hoàng','0375647282',N'Phan Hành Sơn,Đà Nẵng',null,'1287484686'),
('019',N'Hoàng Trung Quân','0375836470',N'Âu Cơ,Đà Nẵng',null,'10010036476'),
('020',N'Mai Thành Công','0375847483',N'Doãn Uẩn,Đà Nẵng','1192898984','10010004466')
go

insert into HOADON(MaHD,NgayLap,TongTien,HinhthucTT,MANB,MAKH)
values
('20001','2023/01/20',NULL, 'TM', '00','001'),
('20002','2023/01/26',NULL, 'CK', '01','002'),
('20003','2023/02/10',NULL, 'TM', '01','003'),
('20004','2023/02/27',NULL, 'CK', '01','004'),
('20005','2023/03/16',NULL, 'CK', '02','005'),
('20006','2023/03/24',NULL, 'TM', '00','006'),
('20007','2023/04/30',NULL, 'TM', '02','007'),
('20008','2023/04/30',NULL, 'CK', '02','008'),
('20009','2023/05/23',NULL, 'TM', '01','009'),
('200010','2023/05/15',NULL, 'TM', '00','010'),
('200011','2023/06/01',NULL, 'TM', '01','011'),
('200012','2023/06/01',NULL, 'CK', '02','012'),
('200013','2023/07/15',NULL, 'TM', '00','013'),
('200014','2023/07/18',NULL, 'CK', '01','014'),
('200015','2023/08/20',NULL, 'TM', '00','015'),
('200016','2023/08/25',NULL, 'CK', '01','016'),
('200017','2023/09/27',NULL, 'TM', '02','017'),
('200018','2023/09/27',NULL, 'TM', '00','018'),
('200019','2023/10/10',NULL, 'CK', '01','019'),
('200020','2023/10/22',NULL, 'TM', '02','020'),
('200021','2023/11/07',NULL, 'CK', '01','001'),
('200022','2023/11/27',NULL, 'TM', '02','002'),
('200023','2023/11/23',NULL, 'CK', '01','013'),
('200024','2023/11/25',NULL, 'TM', '02','014')

insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values ('10001','20001','B003', 3, 55000,165000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10002','20001','D004', 2, 220000,440000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10003','20002','D004',3,220000,660000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10004','20002','C015',4,300000,1200000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10005','20002','TD007',10,30000,300000,N'kg')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10006','20003','LX020',4,40000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10007','20003','ON025',5,40000,200000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10008','20003','N013',20,15000,300000,N'mét')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10052','20004','MB024',5,230000,1150000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10009','20004','Đ010',10,20000,200000,N'hộp')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10010','20005','XM009',5,200000,1000000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10011','20005','N014',20,10000,200000,N'mét')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10012','20005','K016',4,30000,120000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10013','20006','MX008',15,12000,180000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10014','20006','TV018',5,20000,100000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10015','20007','V017',4,150000,600000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10016','20007','Q023',3,200000,600000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10017','20007','GN019',50,5000,250000,N'miếng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10018','20008','LX020',3,40000,120000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10019','20008','XM001',10,80000,800000,N'bao')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10020','20008','ON025',3,40000,120000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10021','20009','G002',500,780,390000,N'viên')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10022','20009','D005',5,420000,2100000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10023','20009','XM009',3,200000,600000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10024','200010','TD007',5,30000,150000,N'kg')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10025','200024','DM022',10,30000,300000,N'dây')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10026','200010','D004',3,220000,660000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10027','200011','TC006',4,15000,60000,N'kg')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10028','200011','OD021',2,80000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10029','200012','C016',5,185000,925000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10030','200012','V017',3,150000,450000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10031','200023','N014',20,10000,200000,N'mét')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10032','200023','XM011',5,15000,75000,N'mét')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10033','200013','G012',3,60000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10034','200013','LX020',5,40000,200000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10035','200014','K016',8,30000,240000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10036','200014','V017',6,150000,900000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10037','200014','ON025',5,40000,200000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10038','200015','GN019',50,5000,250000,N'miếng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10039','200015','MB024',5,230000,1150000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('10040','200015','XM009',5,200000,1000000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100041','200016','XM001', 5, 80000,400000,N'bao')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100042','200016','D004', 200, 780,156000,N'viên')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100043','200017','TD007', 3,30000,90000,N'bao')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100044','200017','Đ010', 1, 20000,20000,N'hộp')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100045','200017','OD021', 2, 80000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100046','200018','Q023', 1, 200000,200000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100047','200019','LX020', 2, 40000,80000,N'viên')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100048','200019','C016', 5, 185000,925000,N'thùng')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100049','200022','MB024', 2, 80000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100050','200020','ON025', 4, 40000,160000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia,ThanhTien,DVT) values('100051','200021','C015', 1, 300000,300000,N'cái')
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong) values('100053','200024','C015', 1)
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong) values('100054','200024','ON025', 3)
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong, DonGia) values('100055','200024','ON025', 3, 10000)
insert into CHITIETHOADON(MaCT,MaHD, MaSP, SoLuong) values('3','200020','C015', 2)
go

go
create or alter trigger tcthdinsert
on CHITIETHOADON
After insert
as
begin
	declare @soluong int, @thanhtien int, @masp varchar(10), @mahd varchar(10), @dongia int ,@mact varchar(10), @donvitinh nvarchar(10)
	select @mact= MaCT,@soluong= Soluong, @thanhtien=ThanhTien, @masp=MaSP, @mahd=MaHD, @dongia=DonGia, @donvitinh=DVT from inserted 
	declare @tongtien int, @slt int
	select @tongtien=TongTien from HOADON where MaHD=@mahd 
	if @tongtien is null
		set @tongtien=0
	declare @dg int, @dvt nvarchar(10)
	select @dg = GiaSP, @dvt=DVT, @slt=SLTon from SANPHAM where @masp=MaSP
	if (@thanhtien is null and @dongia is null and  @donvitinh is null)
	begin
		update CHITIETHOADON set  DonGia = @dg ,ThanhTien=(@dg*@soluong), DVT=@dvt where  MaCT=@mact
	end
	else
	begin
		update CHITIETHOADON set ThanhTien= (@dongia*@soluong), DVT=@dvt where  MaCT=@mact
	end
	--update bảng SANPHAM
	if @slt<@soluong
		rollback transaction
	else
		update SANPHAM set SLTon=(SLTon-@soluong) where MaSP=@masp
	--update bảng HOADON
	update HOADON set TongTien=(@tongtien+@thanhtien) where MaHD=@mahd
end




go
create or alter trigger tcthdupdate
on CHITIETHOADON
After update
as
begin
	declare @soluong int, @thanhtien numeric(15,0)
	select @soluong= Soluong, @thanhtien=ThanhTien from inserted 
	declare @sl int, @tt numeric(15,0), @msp varchar(10), @mhd varchar(10)
	select @sl= Soluong, @tt=ThanhTien, @msp=MaSP, @mhd=MaHD from deleted
	declare @tongtien int, @slt int
	select @tongtien=TongTien from HOADON where MaHD=@mhd 
	if @tongtien is null
		set @tongtien=0
	select @slt=SLTon from SANPHAM where MaSP=@msp
	--update bảng SANPHAM
	if (@slt+@sl)<@soluong
		rollback transaction
	else
		update SANPHAM set SLTon=(SLTon+@sl-@soluong) where MaSP=@msp
	--update bảng HOADON
	update HOADON set TongTien=(TongTien-@tt+@thanhtien) where MaHD=@mhd
end
go


go
create or alter trigger tcthddelete
on CHITIETHOADON
After delete
as
begin
	declare @soluong int, @thanhtien numeric(15,0), @masp varchar(10), @mahd varchar(10) 
	select @soluong= Soluong, @thanhtien=ThanhTien, @masp=MaSP, @mahd=MaHD from deleted 
	declare @tongtien int
	select @tongtien=TongTien from HOADON where MaHD=@mahd 
	if @tongtien is null
		set @tongtien=0
	--update bảng SANPHAM
	update SANPHAM set SLTon=(SLTon+@soluong) where MaSP=@masp
	--update bảng HOADON
	update HOADON set TongTien=(TongTien-@thanhtien) where MaHD=@mahd
end

go
select * from TAIKHOAN
select * from NGUOIBAN
select * from SANPHAM
select * from KHACHHANG
select MaHD, NgayLap, TongTien,HinhthucTT, MaNB,MaKH from HOADON 
select MaCT, MaHD, MaSP,Soluong, DVT, DonGia, ThanhTien from CHITIETHOADON
go



