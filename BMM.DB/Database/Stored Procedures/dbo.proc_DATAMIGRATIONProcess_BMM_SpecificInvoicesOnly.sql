SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[proc_DATAMIGRATIONProcess_BMM_SpecificInvoicesOnly]
	
	@DateTimeVal datetime
		
AS 


BEGIN

--IMPORTANT:  RUN MANUALLY before starting this sequence or invoice numbers will be off!!:  DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

-- Two Step Process Here to Remove payments in the event that any new ones have been entered since 

------------------- INSERTS TO ATTORNEY TABLE---------------------------------

Insert Into Attorney (CompanyID, ContactListID, isActivestatus, FirstName, LastName, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, Temp_AttorneyID, DepositAmountRequired, Active, DateAdded)
Select 1, 16, 1, [Attorney First Name], [Attorney Last Name], [Attorney Address], '', [Attorney City], 19, [Attorney Zip], 
'(' + Left([ATTORNEY Phone], 3) + ') ' + Right(Left([ATTORNEY Phone], 6), 3) + '-' + Right([ATTORNEY Phone], 4), 
'(' + Left([ATTORNEY FAX], 3) + ') ' + Right(Left([ATTORNEY FAX], 6), 3) + '-' + Right([ATTORNEY FAX], 4),
 '', [Memo], [Attorney No], .10 as DepositAmountRequired, 1, --@DateTimeVal 
 '08/6/2013 5:00 PM' 
From [DATAMIGRATION_BMM_SHARED_Attorney_List] 
WHERE [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney Last Name] is not null 
and [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney First Name] is not null

	PRINT 'Attorney Insert:  Attorney Table'


Insert into ContactList (DateAdded, Temp_AttorneyID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1  
from [Attorney]
Where Attorney.ContactListID = 16

	PRINT 'Attorney Insert:  ContactList Table'


Update Attorney
Set ContactListID =  ContactList.ID
From Attorney inner join ContactList on Attorney.ID = ContactList.Temp_AttorneyID
Where Attorney.ContactListID = 16
and Temp_CompanyID = 1
-- ContactListID is temporary to get records inserted initially
	
	
	PRINT 'Attorney Insert:  Attorney Table Update with ContactListID'
	
	PRINT '--ATTORNEY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Surgery)----------------------------------

INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)
Select 1, 16, 1, 
IsNull(DATAMIGRATION_BMM_SURGERY_Providers.Name, 'No Name At Import'), 
Isnull(Address, '9191 Siegen Ln'),
IsNull(City, 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull(Zip, '70810'), 
isnull( '(' + Left([Phone], 3) + ') ' + Right(Left([Phone], 6), 3) + '-' + Right([Phone], 4), 'none'), 
 '(' + Left([FAX], 3) + ') ' + Right(Left([FAX], 6), 3) + '-' + Right([FAX], 4),
Abbrev, discount , 1, 1, DATAMIGRATION_BMM_SURGERY_Providers.provider, 'Surgery' as Temp_Type
 From DATAMIGRATION_BMM_SURGERY_Providers LEFT join States on DATAMIGRATION_BMM_SURGERY_Providers.State = States.Abbreviation

	PRINT 'Provider (Surgery) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Provider
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Temp_CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER SURGERY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Tests)----------------------------------


INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)

Select 1, 16, 1, 
IsNull([Facility Name], 'No Name At Import'), 
Isnull([Facility Address], '9191 Siegen Ln'),
IsNull([Facility City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Facility Zip], '70810'), 
isnull( '(' + Left([Facility Phone], 3) + ') ' + Right(Left([Facility Phone], 6), 3) + '-' + Right([Facility Phone], 4), 'none'), 
 '(' + Left([Facility FAX], 3) + ') ' + Right(Left([Facility FAX], 6), 3) + '-' + Right([Facility FAX], 4),
FacilityAbbrev, discount , 1, 1, DATAMIGRATION_BMM_TEST_Provider_List.[Facility No], 'Test' as Temp_Type
 From DATAMIGRATION_BMM_TEST_Provider_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Provider_List.[Facility State]= States.Abbreviation 

	PRINT 'Provider (TEST) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1
from Provider
Where Provider.ContactListID = 16

	PRINT 'Provider (TEST) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (TEST) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER TEST INSERT COMPLETE--'



-----------------INSERTS TO Physician TABLE --(Tests)----------------------------------


INSERT INTO Physician (CompanyID, ContactListID, isActiveStatus, FirstName, LastName, Street1, Street2, City, 
StateID, ZipCode, Phone, Fax,  Active, Notes, Temp_PhysicianID)

Select 1, 16, 1, 
IsNull([Physician First Name] , 'No Name At Import'),
IsNull([Physician Last Name]  , 'No Name At Import'),
 Isnull([Physician Address] , '9191 Siegen Ln'),
 Isnull([Physician Address2], ''),
IsNull([Physician City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Physician Zip] , '70810'), 
isnull( '(' + Left([Physician Phone], 3) + ') ' + Right(Left([Physician Phone], 6), 3) + '-' + Right([Physician Phone], 4), 'none'), 
 '(' + Left([Physician FAX], 3) + ') ' + Right(Left([Physician FAX], 6), 3) + '-' + Right([Physician FAX], 4),
1, Memo,
DATAMIGRATION_BMM_TEST_Physician_List.[Physician No]
 From DATAMIGRATION_BMM_TEST_Physician_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Physician_List.[Physician State]= States.Abbreviation 

	PRINT 'Physican (TEST) Insert:  Physican Table'
 
Insert Into ContactList (DateAdded, Temp_PhysicianID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Physician
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physican (TEST) Insert:  Contact  List'


Update Physician
Set ContactListID = ContactList.ID
From Physician inner join ContactList on Physician.ID = ContactList.Temp_PhysicianID
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physician (TEST) Insert:  Update of Physician Table with Contact List ID'
	PRINT '--Physician TEST INSERT COMPLETE--'


-------------------------- Insert into Patients (Surgery) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_SURGERY_BMM 
inner join States on DATAMIGRATION_BMM_SURGERY_BMM.[Client State] = States.Abbreviation
Where [DATAMIGRATION_BMM_SURGERY_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]

		PRINT 'Patient SURGERY Insert:  Patient Table'

		PRINT '--Patient (Surgery) INSERT COMPLETE--'




-------------------------- Insert into Patients (TEST) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], 
isnull(SSN, '000000000'), 
isnull([Client Address], 'Not Provided'), 
isnull([Client City], 'none'), 
States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_TEST_BMM 
inner join States on DATAMIGRATION_BMM_TEST_BMM.[Client State] = States.Abbreviation
--Where [DATAMIGRATION_BMM_TEST_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]


		PRINT 'Patient (Test) Insert:  Patient Table'


Insert Into PatientChangeLog (PatientID, UserID, InformationUpdated, Active, Temp_CompanyID)
Select ID, 84,-- TempUserID
 'Initial Import of Patient (Test) Information', 1, 1
From Patient Where Patient.Active = 1 and Patient.CompanyID = 1

		PRINT 'Patient Insert:  Patient Change Log (Test and Surgery)'
		PRINT '--Patient INSERT COMPLETE--'



------------------------- Insert Into InvoiceContactList (Attorney Info:  SURGERY)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM'
--@DateTimeVal
, [Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--Invoice Contact List (Attorney:  SURGERY) INSERT COMPLETE--'


------------------------- INSERT Into INvoiceContactList (Attorney Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
[Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Attorney:  TESTING) INSERT Complete--'
	


------------------------- INSERT Into INvoiceContactList (Provider Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1,  '08/6/2013 5:00 PM',
--@DateTimeVal,
 [Provider No] , [Invoice No], 1
From DATAMIGRATION_BMM_TEST_Test_List
Group By [Provider No], [Invoice No]


	PRINT '--InvoiceContactList (Provider: TESTING) INSERT Complete--'
	

------------------------- INSERT Into INvoiceContactList (Physician Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_PhysicianID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM', [Physician No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Physician:  TESTING) INSERT Complete--'

	


---------------------  INSERT Into InvoiceAttorney (SURGERY)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_Surgery_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_Surgery_BMM 
inner join Attorney on DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
and Attorney.CompanyID = 1

	PRINT '--Invoice Attorney INSERT COMPLETE--'


---------------------  INSERT Into InvoiceAttorney (TESTING)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_TEST_BMM 
inner join Attorney on DATAMIGRATION_BMM_TEST_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Attorney.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1




-----  insert into Invoice_Patient table (Surgery)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_SURGERY_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
and CompanyID = 1

	PRINT '--INVOICE_PATIENT INSERT COMPLETE SURGERY--'


-----  insert into Invoice_Patient table (TESTING)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_TEST_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
and CompanyID = 1


	PRINT '--INVOICE_PATIENT INSERT COMPLETE TESTS--'


--------------------------INSERT SurgeryInvoice


Insert Into SurgeryInvoice ( Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select 1, --@DateTimeVal 
'08/6/2013 5:00 PM', [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--SURGERYINVOICE INSERT COMPLETE--'


-----------------------  Insert TEST

-- only inserts new tests since last import

Insert Into Test (CompanyID, Name, Active, DateAdded)
Select 1, [Test Name] , 1, '08/6/2013 5:00 PM'
 --@DateTimeVal 
From DATAMIGRATION_BMM_TEST_TEST_List LEFT join Test on [Test Name] = [Name]
Where [Test Name] is not null 
and [Name] is null
Group By [Test Name]

Update Test 
Set Temp_TestTypeID = 1
Where (Test.Name Like '%IDET%'
or Test.Name Like '%Disk%'
or Test.Name Like '%Disc%'
or Test.Name Like '%ESI%'
or Test.Name Like '%Facet%'
or Test.Name Like '%Anesthesia'
or Test.Name Like '%Myelogram%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Rhizo%'
or Test.Name Like '%RF%'
or Test.Name Like '%Chiropractic%'
or Test.Name Like '%Injection%'
or Test.Name Like '%Evaluation%'
or test.Name Like '%treatment%'
or test.name Like '%MBB%'
or test.name Like '%Branch%'
or test.name Like '%TP%'
or test.name like '%ONB%'
or test.name like '%OCB%'
or test.name like '%Occipital%'
or test.name like '%eval%'
or test.name like '%Procedure%'
or test.name like '%Office%'
Or test.name like '%Visit%'
or test.name like '%Denervation%'
or test.name like '%SNRB%'
or test.name like '%Transfor%'
or test.name like '%Radio%'
or test.name like '%Arth%'
or test.name like '%Block%'
)
and CompanyID = 1

Update Test 
Set Temp_TestTypeID = 2 -- MRI
Where (Test.Name Like '%MRI%'
or Test.Name Like '%MIR%'
or Test.Name Like '%Lumbar%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Thoracic%'
or Test.Name Like '%complete%'
or Test.Name Like '%lumbar%')
and CompanyID = 1


Update Test 
Set Temp_TestTypeID = 3 -- OTHER
Where (Test.Name Like '%blood%'
or Test.Name Like '%work%'
or Test.Name Like '%dmx%'
or Test.Name Like '%sedation%'
or Test.Name Like '%urinalysis%'
or Test.Name Like '%fluor%'
or Test.Name Like '%fee%'
or Test.Name Like '%ems%'
or Test.Name Like '%sleep%'
or Test.Name Like '%study%'
or Test.Name Like '%no show%'
or Test.Name Like '%eeg%'
or test.Name Like '%24 hour%'
or test.name Like '%blood patch%'
or test.name Like '%ultra%'
or test.name Like '%radiology%'
or test.name like '%CT%'
or test.name like '%x-ray%'
or test.name like '%ray%'
or test.name like '%scan%'
or test.name like '%CAT%'
or test.name like '%Physical%'
Or test.name like '%Therapy%'
or test.name like '%Gadolinium%'
or test.name like '%FEE%'
or test.name like '%Contrast%'
or test.name like '%EMG%'
or test.name like '%NCV%'
or test.name like '%SSEP%'
or test.name like '%DEP%'
or test.name like '%MRA%'
or test.name like '%MR%'
or test.name like '%Angiogram%'
or test.name like '%Ultrasound%'
or test.name like '%Mammogram%'
or test.name like '%Medical Records%'
or Test.Name like '%left elbow%')
and CompanyID = 1
and Temp_TestTypeID is null

--and Temp_TestTypeID <> 1 and Temp_TestTypeID <> 2

	PRINT '--Updates to Test Name Complete--'


-------------------------INSERT InvoicePhysician (for TESTING)

Insert Into InvoicePhysician (PhysicianID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, EmailAddress, Notes, 
Active, DateAdded, Temp_InvoiceNumber, Temp_PhysicianID, Temp_CompanyID)

SELECT Physician.ID, InvoiceContactList.ID, 1, Physician.FirstName, Physician.LastName,
Physician.Street1, Physician.Street2, Physician.City, Physician.StateID, Physician.ZipCode,
Physician.Phone, Physician.Fax, Physician.EmailAddress, Physician.Notes, 
Physician.Active, Physician.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], PHysician.Temp_PhysicianID, 1
From DataMigration_BMM_TEST_BMM 
inner join Physician on DATAMIGRATION_BMM_TEST_BMM.[Physician No] =
Physician.Temp_PhysicianID 
inner join InvoiceContactList on InvoiceContactList.Temp_PhysicianID = Physician.Temp_PhysicianID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Physician.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1

--Select * From Test Where Temp_TestTypeID is null and CompanyID = 2

--------------------------INSERT TESTInvoice

Insert Into TestInvoice ( TestTypeID, Active, DateAdded, Temp_TestNo, Temp_InvoiceID, Temp_CompanyID)
Select Max(Test.Temp_TestTypeID), 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
Max(DATAMIGRATION_BMM_TEST_TEST_List.[Test No]), DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No], 1 
from DATAMIGRATION_BMM_TEST_TEST_List inner join Test on Test.Name = DataMigration_BMM_TEst_Test_List.[Test Name]
and Test.CompanyID = 1
Group By DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
having MAX(Test.Temp_TestTypeID) is not null -- Needs to pull as an exception 
--AND DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = 1711

--Select * From DATAMIGRATION_BMM_TEST_BMM Where [Invoice Number] = 8067 
--Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
--Select * From InvoicePhysician Where Temp_InvoiceNumber = 1714
	PRINT '--INSERT TEST INVOICE COMPLETE--'

--Select * From InvoiceContactList Where Temp_Invoice = 8067

--Where InvoiceContactList.Temp_ProviderID in (5074, 5075)	
	
Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, 
Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, 
Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, 
DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_ProviderID, Temp_InvoiceID, Temp_CompanyID)

Select InvoiceContactList.ID, Provider.ID, Provider.isActiveStatus, 
Provider.Name, Provider.Street1, Provider.Street2, Provider.City, Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email,
Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage,
Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, 
InvoiceContactList.Temp_Invoice, InvoiceContactList.Temp_CompanyID

From InvoiceContactList inner join Provider on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
inner join DATAMIGRATION_BMM_TEST_Test_List on InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
and DATAMIGRATION_BMM_TEST_Test_List.[Provider No] = InvoiceContactList.Temp_ProviderID

Where InvoiceContactList.Temp_CompanyID = 1
and Provider.CompanyID = 1
and Provider.Temp_Type = 'Test'
order by Temp_Invoice

--and InvoiceContactList.Temp_Invoice 
-- Stopped here 6/12/2013  too many providers iwthout invoice...
--Select * From Provider Where Temp_ProviderID = 121

--Select * From InvoiceContactList where Temp_ProviderID = 121 and Temp_CompanyID = 1

	PRINT '--INSERT INvoice Contact List:  Providers (TEST Invoice)'


----------------------- Convert Times in DATAMIGRATION_BMM_TEST_TEST_List TABLE ----

/*Select [Test time],  (LTRIM([Test Time])) + ' PM'
From DATAMIGRATION_BMM_TEST_TEST_List 
WHERE
Len(LTRIM([Test Time])) = 4
and (LTRIM([Test Time])) Not Like '%P%' 
and (LTRIM([Test Time])) Not Like '%A%' 
and LEFT((LTRIM([Test Time])), 1) Like '1%'
*/


----------------------- Insert TestInvoice_TEST
Delete From TestInvoice_Test where Temp_CompanyID = 1


Insert Into TestInvoice_Test (TestInvoiceID, TestID, InvoiceProviderID, Notes, TestDate, TestTime, NumberOfTests,
MRI, IsPositive, isCanceled, TestCost, PPODiscount, AmountToProvider, CalculateAmountToProvider, ProviderDueDate, 
DepositToProvider, AmountPaidToProvider, Date, CheckNumber, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID) 

Select TESTInvoice.ID, 
Test.ID, 
InvoiceProvider.ID, 
'test', 
isnull(Convert(date, [Test Date]), '1/1/1900'), 
--ISNULL([TestTimeTIME], '11:59 PM'),
'8:00 PM',

[Number of Tests], 
ISNULL([MRI], 0), 
Case When [Test Results] = 'Negative' Then 0
When [Test Results] = 'Positive' Then 1
When [Test Results] = null then ''
End as IsPositive, 
Canceled, 
isnUll([Test Cost], 0), 
IsNull([PPO Discount], 0), 
IsNull([Amount Paid To Provider],0), 
IsNull([Amount Paid To Provider],0), 

Case When (Convert(date,[Amount Due To Provider Due Date])) is null Then '1/1/2099'
When (Convert(date,[Amount Due To Provider Due Date])) is not null Then (Convert(date,[Amount Due To Provider Due Date])) 
End [Amount Due To Provider Due Date],

[Amount Paid To Provider], 
[Amount Paid To Provider],  
Convert(date,[Amount Due To Provider Due Date]),
[Amount Paid To Provider Check No], 
1 as Active, 

--@DateTimeVal as DateAdded,
'08/6/2013 5:00 PM' as dateadded,
TESTInvoice.Temp_InvoiceID,
1 as Temp_CompanyID 

--Select * 
From TestInvoice inner join DATAMIGRATION_BMM_TEST_BMM 
on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]

inner join DataMigration_BMM_TEST_TEST_List on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
= DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] 
inner join TEST on TEST.Name = DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] 
--Where DATAMIGRATION_BMM_TEST_Test_List.[Invoice No] = 1002

inner join InvoiceProvider on DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = InvoiceProvider.Temp_INvoiceID  
and DATAMIGRATION_BMM_TEST_TEST_List.[Provider no] = InvoiceProvider.Temp_ProviderID 

LEFT Join Temp_TestTimeValConversionTEXTToTime 
on DATAMIGRATION_BMM_TEST_TEST_LIST.[Test time] = Temp_TestTimeValConversionTEXTToTime.TestTimeTEXT  
Where TEST.CompanyID = 1 and 
TestInvoice.Temp_CompanyID = 1
and InvoiceProvider.Temp_CompanyID = 1
--and TestInvoice.Temp_InvoiceID = 1002
order by TestInvoice.Temp_InvoiceID

--Select * from INvoiceProvider Where InvoiceProvider.Temp_CompanyID = 1 and InvoiceProvider.Temp_InvoiceID = 1002
--Select * From DATAMIGRATION_BMM_TEST_Test_List Where [Invoice No] = 1002

--Select * From TestInvoice where Temp_InvoiceID = 1002
--and DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] = 1714


--Select * From InvoiceProvider Where Temp_InvoiceID = 1714

--Select [Invoice no] From DATAMIGRATION_BMM_TEST_TEST_LIST  
--Group by [Invoice No]
--order by [Invoice No]


--Select [Temp_InvoiceID] From TestInvoice
--Group By [Temp_InvoiceID] 
--order by Temp_InvoiceID


--Select * From DATAMIGRATION_BMM_TEST_TEST_LIST
--Where [Invoice No] = 1711

--and [Amount Due To Provider Due Date] is not null -- Add to Exceptions  12/19/2012:  Commenting Out for TEST Invoices Only Because Believed to be Culprit on why some test info is not populating on certain invoices.

 /*

Select * From InvoiceProvider Where Temp_InvoiceID = 8067
Select * From DATAMIGRATION_BMM_TEST Where Provider
Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
Select * From Test Where Test.Name = 'RADIOLOGY FEE' OR Test.Name = 'Cervical Spect Scan & X-rays'
Select * From TestINvoice_TEST Where TestINvoice_Test.Temp_InvoiceID = 8067
*/

/*
SELECT     Test.ID AS [Test.ID], Test.CompanyID, TestInvoice.ID AS [TestInvoice.iD], Test.Name AS [Test.Name], Provider.ID AS [Provider.ID]
FROM         DATAMIGRATION_BMM_TEST_BMM INNER JOIN
                      DATAMIGRATION_BMM_TEST_TEST_List ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] INNER JOIN
                      Test ON DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] = Test.Name INNER JOIN
                      TestInvoice ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = TestInvoice.Temp_InvoiceID INNER JOIN
                      Provider ON DATAMIGRATION_BMM_TEST_BMM.[Provider No] = Provider.Temp_ProviderID
WHERE     (Test.CompanyID = 2)

*/


-----------------------  InSERT Surgery

Insert Into Surgery (CompanyID, Name, Active, DateAdded)
Select 1, SurgeryType, 1,  '08/6/2013 5:00 PM'
--@DateTimeVal 
From DATAMIGRATION_BMM_SURGERY_BMM
where SurgeryType is not null
Group By SurgeryType




	PRINT '--SURGERY INSERT COMPLETE--'



----------------------- Insert SurgeryInvoice_Surgery

Insert Into SurgeryInvoice_Surgery (SurgeryInvoiceID, SurgeryID, isInpatient, Notes, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select SurgeryInvoice.ID, Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.inpatient, DATAMIGRATION_BMM_SURGERY_BMM.Notes,
1, '08/6/2013 5:00 PM',
--@DateTimeVal , 
SurgeryInvoice.Temp_InvoiceID, 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1


	PRINT '--SURGERYINVOICE_SURGERY INSERT COMPLETE--'


------------------------ Insert SurgeryInvoice_SurgeryDates

Insert Into SurgeryInvoice_SurgeryDates (SurgeryInvoice_SurgeryID, ScheduledDate, isPrimaryDate, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '08/6/2013 5:00 PM',
--@DateTimeVal ,
 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1
and DATEScheduled is not null

	PRINT '--SURGERYINVOICE_SURGERYDATES INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) SURGERY

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM' , Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number], 1  
from DATAMIGRATION_BMM_SURGERY_BMM inner join DATAMIGRATION_BMM_SURGERY_Services
on DATAMIGRATION_BMM_SURGERY_BMM.[invoice number] = DATAMIGRATION_BMM_SURGERY_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) TEST
/*

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '10/10/2012 12:30 PM' , Provider, DATAMIGRATION_BMM_TEST_BMM.[Invoice Number], 2  
from DATAMIGRATION_BMM_TEST_BMM inner join DATAMIGRATION_BMM_TEST_Services
on DATAMIGRATION_BMM_TEST_BMM.[invoice number] = DATAMIGRATION_BMM_TEST_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'
*/
-------------------------- Insert InvoiceProvider (Surgery) --------

Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_providerID, Temp_InvoiceID, Temp_CompanyID)
Select InvoiceContactList.ID as InvoiceContactListID, Provider.ID as ProviderID, 1 as isActiveStatus, Provider.Name, Provider.Street1, Provider.Street2, Provider.City, 
Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email, Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage, Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, InvoiceContactList.Temp_Invoice, 1

From InvoiceContactList inner join dbo.Provider 
on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
Inner join DATAMIGRATION_BMM_SURGERY_BMM on 
InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
WHERE Provider.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1
and Provider.Temp_Type = 'Surgery'

--WHERE Temp_Invoice = 2883

	PRINT '--INVOICEPROVIDER INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Providers ---------------------------

Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded, Temp_InvoiceID, Temp_ProviderID, Temp_CompanyID) 
Select SurgeryInvoice.ID, InvoiceProvider.ID, 1 as Active, '08/6/2013 5:00 PM',
--@DateTimeVal , 
InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID, 1
From InvoiceProvider inner join SurgeryInvoice 
on InvoiceProvider.Temp_InvoiceID = SurgeryInvoice.Temp_InvoiceID
where InvoiceProvider.Temp_CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1

--WHERE InvoiceProvider.Temp_InvoiceID = 2883
--Group By SurgeryInvoice.ID, InvoiceProvider.ID, InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID 
/*
Select * From SurgeryInvoice
WHERE SurgeryInvoice.Temp_InvoiceID  = 8000

SELECT * From InvoiceProvider
WHERE InvoiceProvider.Temp_InvoiceID  = 8000
*/


	PRINT '--SURGERYINVOICE_PROVIDERS INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_Services -------------------

/*Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded)

Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount, 
(1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount) * DATAMIGRATION_BMM_SURGERY_Services.cost as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1, '9/25/2012 10:52 AM' 
From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID
*/

Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded, Temp_ServiceID, Temp_CompanyID)

--Select * From SurgeryInvoice_Providers
--Where SurgeryInvoice_Providers.Temp_InvoiceID = 2883

--Select * From DATAMIGRATION_BMM_SURGERY_Services
--Where [Invoicenumber] = 2883


Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount,--<--Leaving as is until checked 
DATAMIGRATION_BMM_SURGERY_SERVICES.PPODiscount as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1,
-- @DateTimeVal , 
'08/6/2013 5:00 PM',
Temp_ServiceID, 1 
-- SELECT *

From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID

--WHERE SurgeryInvoice_Providers.Temp_InvoiceID = 2883
--order by DATAMIGRATION_BMM_SURGERY_SERVICES.Cost

Where SurgeryInvoice_Providers.Temp_CompanyID = 1

	PRINT '-- SURGERYINVOICE_PROVIDER_SERVICES INSERT COMPLETE--'


---------------------------Insert Surgery CPT Codes in the event not on disk -----------

Insert into CPTCodes (Active, Code, CompanyID, DateAdded, Description)

Select 1, CPtCode, 1, --@DateTimeVal, 
'08/6/2013 5:00 PM',
IsNull(Min(DATAMIGRATION_BMM_SURGERY_CPTCHARGES.[Description]), 'None Provided')
From DATAMIGRATION_BMM_SURGERY_CPTCharges left join CPTCodes 
on DATAMIGRATION_BMM_SURGERY_CPTCharges.cptcode  = CPTCodes.Code
WHERE CPTCodes.Code is null and Len(CPTCode) > 1
and CPTCodes.CompanyID = 1
Group By CPTCode

	PRINT '--CPTCODES INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_CPTCode -------------------

--- NEED TO VERIFY THAT IMPORTED CPT CODES (from Disk) are not missing any codes that are currently in use in DATAMIGRATION_BMM_SURGERY_CPTCODES

Insert Into SurgeryInvoice_Provider_CPTCodes (SurgeryInvoice_ProviderID, CPTCodeID, Amount, Description, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select SurgeryInvoice_Providers.ID, CPTCodes.ID, isnull(DATAMIGRATION_BMM_SURGERY_CPTCharges.Amount, 0), 

Case WHEN DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is null then 'Not Provided'
WHEN  DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is not null then DATAMIGRATION_BMM_SURGERY_CPTCharges.description
END
,
  1, --@DateTimeVal , 
  '08/6/2013 5:00 PM',1, DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number]
--Select * 
From DATAMIGRATION_BMM_SURGERY_CPTCharges inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_CPTCharges.Provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join CPTCodes on DATAMIGRATION_BMM_SURGERY_CPTCharges.CPTCode  = CPTCodes.Code 
Where CPTCodes.CompanyID = 1 
--and DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = 5836
and SurgeryInvoice_Providers.Temp_CompanyID  = 1
order by Code



	PRINT '--SURGERYINVOICE_PROVIDER_CPTCODES INSERT COMPLETE--'



------------------- Insert Survery Invoice_Providers

/* ALREADY DONE ABOVE  Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded)

Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '9/18/2012 3:07 PM' 
From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on 
SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 2 */




--------------------------INSERT INTO Invoice Table (Surgery)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, --InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, --TestInvoiceID, 
SurgeryInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  Or Cancelled = 1 THEN   
		2    
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() < [Invoice Date] + 390  THEN
		1
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() > [Invoice Date] + 390  THEN
		3    
		
		WHEN [Invoice Date] is null THEN
		1
		
	END,
        
	DATAMIGRATION_BMM_SURGERY_BMM.CompleteFile AS isComplete,
	--0 as INvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	2 as InvoiceTypeID, -- For Surgery
	--0 as TestINvoiceID,
	SurgeryInvoice.ID as SurgeryInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] as DateAdded
	--Select *
	FROM dbo.DATAMIGRATION_BMM_SURGERY_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join SurgeryInvoice on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_Surgery_CalcTestListTemp 
	on DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] = DATAMIGRATION_BMM_SUrgery_CalcTestListTemp.InvoiceNumber
	
	Where DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] is not null 
	and Attorney.CompanyID = 1
	and Patient.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID =1
	and SurgeryInvoice.Temp_CompanyID = 1
	and DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] <>  2814  ---- problem here had to exclude this one because was giving null CalcCumINterest

	order by DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	


	PRINT '--SURGERY INVOICE INSERT COMPLETE--'



--------------------------INSERT INTO Invoice Table (Testing)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, TestInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  THEN   
		2    
		
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0   and (GetDate() < [Invoice Date] + 390 or [Invoice Date] is null) THEN  
		1
	
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0  and GetDate() > [Invoice Date] + 390  THEN
		3    
	END,
        
	DATAMIGRATION_BMM_TEST_BMM.CompleteFile AS isComplete,
	InvoicePhysician.ID as InvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	1 as InvoiceTypeID, -- For TEST
	--0 as TestINvoiceID,
	TestInvoice.ID as TestInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_TEST_BMM.AmortizationDate, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_Test_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments WHERE  
		DATAMIGRATION_BMM_TEST_Payments.[Invoice No]  = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	--@DaateTimeVal
	'08/6/2013 5:00 PM' 
	as DateAdded  -- Should be DateScheduled but needs to pull from test detail [Test Date]]
	--Select *
	FROM dbo.DATAMIGRATION_BMM_TEST_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_TEST_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] 
	= DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoicePhysician on InvoicePhysician.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	and InvoicePhysician.Temp_PhysicianID = DATAMIGRATION_BMM_TEST_BMM.[Physician No] 
	inner join TestInvoice on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_SURGERY_CalcTestListTemp 
	on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_CalcTestListTemp.InvoiceNumber
	
	Where Patient.CompanyID =1
	and Attorney.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID = 1
	and InvoicePhysician.Temp_CompanyID = 1
	and TestInvoice.Temp_CompanyID =1

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice;
	PRINT '--INVOICE INSERT TESTS COMPLETE--'



----------------------------------- insert into Payments (SURGERY)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.DatePaid, amount, 
DATAMIGRATION_BMM_SURGERY_PAYMENTSBYAttorney.[check], 
1, '08/6/2013 5:00 PM' 
--@DateTimeVal
 , 1, [invoice number]  
From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.PaymentType = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = Invoice.InvoiceNumber
where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'
		

----------------------------------- insert into Payments (TESTS)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, isnull(DATAMIGRATION_BMM_TEST_Payments.[Date Paid], '1/1/1900'), isnull(amount, 0), 
isnull(DATAMIGRATION_BMM_TEST_Payments.[check no], 0), 
1, '08/6/2013 5:00 PM'
--@DateTimeVal
 , 1, [invoice no]  
From DATAMIGRATION_BMM_TEST_Payments inner join PaymentType on DATAMIGRATION_BMM_TEST_Payments.[Payment Type] = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = Invoice.InvoiceNumber
Where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'


------------------------------------ insert into SurgeryInvoice_Provider_Payments

Insert into SurgeryInvoice_Provider_Payments (SurgeryInvoice_ProviderID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Providers.ID, Paymenttype.ID , DatePaid, Amount, isnull(DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Check], '0000'),  
1, '08/6/2013 5:00 PM'
--@DateTimeVal
, 1 
From SurgeryInvoice_Providers inner join DATAMIGRATION_BMM_SURGERY_PaymentsToProviders 
on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID and
DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.PaymentType = PaymentType.Name 
Where DatePaid is not null and SurgeryInvoice_Providers.Temp_CompanyID = 1 

	PRINT '--SURGERYINVOICE_PROVIDER_PAYMENTS INSERT COMPLETE--'



--Select * From Invoice Where InvoiceNumber = 8024

-- WHERE IS TESTING Provider Payment Info???

------------------------------------ STARTS Patient Record Consolidation Process ----------------------------------------------
--Select * From Invoice

Update  Patient 
Set SSN = '000000000'
Where LEN(SSN) < 3
and CompanyID = 1

Update Patient
Set  SSN = REPLACE(ssn, '-', '')
Where SSN Like '%-%'
and CompanyID = 1

--- Complete Four Times:  Time 1 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 2 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHere Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 3 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHERE Temp_CompanyID = 1


Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1


--- Complete Four Times:  Time 4 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where InvoicePatient.Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

-- IMPORTANT:  NEED TO RUN this items below MANUALLY!!! Does not work in a stored proc..

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice

END


GO
