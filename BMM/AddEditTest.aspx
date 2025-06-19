<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditTest.aspx.cs" Inherits="BMM.AddEditTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">window.history.forward();</script>
    <style type="text/css">
        #Content h2
        {
            margin: 20px 0 10px 0;
            clear: both;
        }
        #Content .ErrorText
        {
            display: block;
        }
        
        #Content table.FormTable 
        {
            margin: 0 0 10px 0;
        }
        #Content table.FormTable > tbody > tr > th
        {
            text-align: right;
            vertical-align: top;
            font-size: 14px;
            font-weight: bold;
            padding: 4px 10px 0 0;
        }
        #Content table.FormTable > tbody > tr > td
        {
            vertical-align: top;
        }
        #Content table.FormTable > tbody > tr > td + th 
        {
            padding-left: 10px;
        }
        #Content table.FormTable > tbody > tr + tr > th
        {
            padding-top: 12px;
        }
        #Content table.FormTable > tbody > tr + tr > td 
        {
            padding-top: 8px;
        }

        
        #Content table.TestRecord 
        {
            float: left;
        }
        #Content table.TestRecord > tbody > tr > th + td
        {
            width: 230px;
        }
        #Content table.TestRecord > tbody > tr > th + td + td
        {
            vertical-align: middle;
        }
        #Content table.TestRecord .riTextBox
        {
            width: 200px !important;
        }
        #Content table.TestRecord .RadPicker,
        #Content table.TestRecord .RadComboBox
        {
            width: 208px !important;
        }
        #Content table.TestRecord .RadPicker .riTextBox
        {
            /*width: 100% !important;*/
        }
        
        
        #Content table.PaymentInfo
        {
            float: left;
            background-color: #E4DFC8;
            margin: 0 0 0 30px;
        }
        #Content table.PaymentInfo > tbody > tr > th
        {
            text-align: left;
            padding: 5px 10px 0 10px;
        }
        #Content table.PaymentInfo > tbody > tr > td
        {
            padding: 0 10px;
        }
        #Content table.PaymentInfo > tbody > tr + tr > th
        {
            padding: 0 10px;
        }
        #Content table.PaymentInfo > tbody > tr + tr > td
        {
            padding: 0 10px 5px 10px;
        }
        
        
        #Content table.CPTCodes > tbody > tr + tr > th
        {
            padding-top: 14px;
        }
        #Content table.CPTCodes > tbody > tr + tr > td
        {
            padding-top: 10px;
        }
        #Content table.CPTCodes > tbody > tr > td + td 
        {
            padding-left: 5px;
        }
        #Content table.CPTCodes .Textbox
        {
            width: 150px;
        }
        #Content table.CPTCodes .RadComboBox
        {
            width: 150px !important;
        }
        #Content table.CPTCodes
        {
            margin-bottom: 10px;
        }
        
        #Content table.TotalCPTs 
        {
            margin: 10px 0;
        }
        #Content table.TotalCPTs .riTextBox
        {
            width: 130px !important;
        }
        
        #Content table.TestRecord .riSingle,
        #Content table.TestRecord textarea.riTextBox,
        #Content textarea
        {
            width: 400px !important;
            height: 100px;
        }

         #Content table.TestRecord div.Normal .riSingle
        {
            width: auto;
            height: auto;
        }
        
        #Content table.TestRecord .rcInputCell .riSingle 
        {
            width: auto !important;
            height: auto !important;
        }
        
        #Content .Buttons
        {
            margin-top: 10px;
            text-align: right;
        }
        #Content label {
            font-weight: bold !important
        }
    </style>
    <script type="text/javascript">
        function EditCPTCharge(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditCPTCharge.ClientID %>').click();
        }
        function ConfirmDeleteCPTCharge(id) {
            var oWnd = $find("<%= ConfirmDeleteCPTCharge.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteCPTCharge.aspx?isk=<%= InvoiceSessionKey %>&tsk=<%= TestSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteCPTChargeClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteCPTCharge.ClientID %>').click();
            }
        }
        $(function () {
            $('#ProviderInfo').click(function () {
                var id = $find('<%= rcbProviderID.ClientID %>').get_value();
                if (id != '') {
                    if (id == $('#<%= txtProviderID.ClientID %>').val()) {
                        $find("<%= RadWindowManager.ClientID %>").open("/Windows/ProviderInfoPopUp.aspx?ipid=" + $('#<%= txtInvoiceProviderID.ClientID %>').val(), "ProviderInformation");
                    }
                    else {
                        $find("<%= RadWindowManager.ClientID %>").open("/Windows/ProviderInfoPopUp.aspx?id=" + id, "ProviderInformation");
                    }
                }
            });
        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="Hidden">
        <asp:TextBox ID="txtID" runat="server" />
        <asp:TextBox ID="txtProviderID" runat="server" />
        <asp:TextBox ID="txtInvoiceProviderID" runat="server" />
        <asp:Button ID="btnEditCPTCharge" runat="server" OnClick="btnEditCPTCharge_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteCPTCharge" runat="server" OnClick="btnDeleteCPTCharge_Click" CausesValidation="false" />
    </div>


    <h1><asp:Literal ID="litAddEditHeader" runat="server" /></h1>

    <table class="TestRecord FormTable" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>Provider:</th>
                <td>
                    <telerik:RadComboBox ID="rcbProviderID" runat="server" OnSelectedIndexChanged="rcbProviderID_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" />
                    <asp:RequiredFieldValidator ID="rfvProviderID" runat="server" ControlToValidate="rcbProviderID" Text="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <td><a href="javascript:void(0);" id="ProviderInfo">See More Info</a></td>
            </tr>
            <tr>
                <th>Account Number:</th>
                <td colspan="2">
                    <div class="Normal">
                        <telerik:RadTextBox ID="txtAccountNumber" runat="server" OnTextChanged="txtAccountNumber_TextChanged" MaxLength="50"></telerik:RadTextBox>
                    </div>
                </td>
                <td></td>
            </tr>
            <tr>
                <th>Test Name:</th>
                <td><telerik:RadComboBox ID="rcbTestID" runat="server" OnSelectedIndexChanged="rcbTestID_SelectedIndexChanged" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" /></td>
                <td><asp:RequiredFieldValidator ID="rfvTestID" runat="server" ControlToValidate="rcbTestID" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
            </tr>
            <tr>
                <td colspan="3" align="right"><Telerik:RadSpell ID="splchkNotes" runat="server" ButtonType="ImageButton" ButtonText="" FragmentIgnoreOptions="All" ControlToCheck="txtNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></td>
            </tr>
            <tr>
                <th>Notes on Test:</th>
                <td colspan="2"><telerik:RadTextBox ID="txtNotes" runat="server" TextMode="MultiLine" OnTextChanged="txtNotes_TextChanged" MaxLength="1000" /></td>
            </tr>
            <tr>
                <th>Test Date:</th>
                <td><telerik:RadDatePicker ID="rdpTestDate" runat="server" OnSelectedDateChanged="rdpTestDate_SelectedDateChanged" /></td>
                <td><asp:RequiredFieldValidator ID="rfvTestDate" runat="server" ControlToValidate="rdpTestDate" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
            </tr>
            <tr>
                <th>Test Time:</th>
                <td colspan="2"><telerik:RadTimePicker ID="rtpTestTime" runat="server" OnSelectedDateChanged="rtpTestTime_SelectedDateChanged" /></td>
            </tr>
            <tr>
                <th>Number of Tests:</th>
                <td colspan="2"><telerik:RadNumericTextBox ID="txtNumberOfTests" runat="server" OnTextChanged="txtNumberOfTests_TextChanged" Type="Number" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="0" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
            </tr>
            <tr>
                <th>Alternative Test Procedures:</th>
                <td><telerik:RadNumericTextBox ID="txtMRI" runat="server" OnTextChanged="txtMRI_TextChanged" AutoPostBack="true" CausesValidation="false" Type="Number" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="0" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                <td><asp:RequiredFieldValidator ID="rfvMRI" runat="server" ControlToValidate="txtMRI" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
            </tr>
            <tr>
                <th>Results</th>
                <td colspan="2">
                    <telerik:RadComboBox ID="rcbResults" runat="server" OnSelectedIndexChanged="rcbResults_SelectedIndexChanged" EmptyMessage="Select" MarkFirstMatch="true">
                        <Items>
                            <telerik:RadComboBoxItem Text="" Value="" />
                            <telerik:RadComboBoxItem Text="Positive" Value="true" />
                            <telerik:RadComboBoxItem Text="Negative" Value="false" />
                        </Items>
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <th></th>
                <td colspan="2"><asp:CheckBox ID="cbxCancelled" runat="server" Text="Cancelled" TextAlign="Right" OnCheckedChanged="cbxCancelled_CheckedChanged" /></td>
            </tr>
            <tr>
                <th>Test Cost:</th>
                <td><telerik:RadNumericTextBox ID="txtTestCost" runat="server" OnTextChanged="txtTestCost_TextChanged" AutoPostBack="true" CausesValidation="false" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                <td><asp:RequiredFieldValidator ID="rfvTestCost" runat="server" ControlToValidate="txtTestCost" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
            </tr>
            <tr>
                <th>PPO Discount:</th>
                <td><telerik:RadNumericTextBox ID="txtPPODiscount" runat="server" OnTextChanged="txtPPODiscount_TextChanged" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                <td><asp:RequiredFieldValidator ID="rfvPPODiscount" runat="server" ControlToValidate="txtPPODiscount" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
            </tr>
        </tbody>
    </table>

    <div style="padding:0 0 10px 30px; float:left">
    <asp:Button ID="btnLetterToPatient" runat="server" OnClick="btnLetterToPatient_Click" Text="Letter to Patient" />
    <asp:Button ID="btnGuarantorAuthorization" runat="server" OnClick="btnGuarantorAuthorization_Click" Text="Guarantor Authorization" />
    </div>

    <table class="PaymentInfo FormTable">
        <tbody>
            <tr><th>Amount to Provider:</th></tr>
            <tr><td>
                    <telerik:RadNumericTextBox ID="txtAmountToProvider" runat="server" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" OnTextChanged="txtAmountToProvider_TextChanged" />
                    <asp:CheckBox runat="server" ID="cbxCalculate" OnCheckedChanged="cbxCalculate_CheckedChanged" Text="Auto-calculate?" AutoPostBack="true" />
            </td></tr>
            <tr><th>Provider Due Date:</th></tr>
            <tr>
                <td>
                    <telerik:RadDatePicker ID="rdpProviderDueDate" runat="server" OnSelectedDateChanged="rdpProviderDueDate_SelectedDateChanged" />
                    <asp:RequiredFieldValidator ID="rfvProviderDueDate" runat="server" ControlToValidate="rdpProviderDueDate" Text="Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
            </tr>
            <tr><th>Deposit to Provider:</th></tr>
            <tr><td><telerik:RadNumericTextBox ID="txtDepositToProvider" runat="server" OnTextChanged="txtDepositToProvider_TextChanged" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td></tr>
            <tr><th>Amount Paid to Provider:</th></tr>
            <tr><td><telerik:RadNumericTextBox ID="txtAmountPaidToProvider" runat="server" OnTextChanged="txtAmountPaidToProvider_TextChanged" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td></tr>
            <tr><th>Date:</th></tr>
            <tr><td><telerik:RadDatePicker ID="rdpDate" runat="server" OnSelectedDateChanged="rdpDate_SelectedDateChanged" /></td></tr>
            <tr><th>Check Number:</th></tr>
            <tr><td><telerik:RadTextBox ID="txtCheckNumber" runat="server" OnTextChanged="txtCheckNumber_TextChanged" MaxLength="50" /></td></tr>
        </tbody>
    </table>


    <h2>CPT Charges</h2>
    <table class="CPTCodes FormTable" id="tblAddEditCPTCharges" runat="server" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>CPT Code:</th>
                <td>
                    <telerik:RadComboBox ID="rcbCPTCodeID" runat="server" AllowCustomText="true" MinFilterLength="3" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" EnableLoadOnDemand="true"
                        OnSelectedIndexChanged="rcbCPTCodeID_SelectedIndexChanged" OnItemsRequested="rcbCPTCodeID_ItemsRequested" AutoPostBack="true" CausesValidation="false" EnableItemCaching="true" />
                    <asp:RequiredFieldValidator ID="rfvCPTCode" runat="server" ValidationGroup="CPTCharge" ControlToValidate="rcbCPTCodeID" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                    <asp:CustomValidator ID="cvCPTCode" runat="server" CssClass="ErrorText" ControlToValidate="rcbCPTCodeID" ValidationGroup="CPTCharge" ErrorMessage="Please select a valid CPT Code." OnServerValidate="rcbCPTCodeID_ValidateCPTCode"></asp:CustomValidator>
                </td>
                <th>Amount:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtAmount" runat="server" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                    <asp:RequiredFieldValidator ID="rfvAmount" runat="server" ValidationGroup="CPTCharge" ControlToValidate="txtAmount" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                    
                </td>
            </tr>
            <tr>
                <td colspan="4" align="right"><Telerik:RadSpell ID="splchkDescription" runat="server" ButtonType="ImageButton" ButtonText="" FragmentIgnoreOptions="All" ControlToCheck="txtDescription" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></td>
            </tr>
            <tr>
                <th>Description:</th>
                <td colspan="3"><telerik:RadTextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="1000" /></td>
            </tr>
            <tr>
                <td colspan="4" style="text-align:right">
                    <asp:Button ID="btnCPTChargeAdd" runat="server" Text="Add" OnClick="btnCPTChargeAdd_Click" ValidationGroup="CPTCharge" />
                    <asp:Button ID="btnCPTChargeCancel" runat="server" Text="Cancel" OnClick="btnCPTChargeCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnCPTChargeSave" runat="server" Text="Save" OnClick="btnCPTChargeSave_Click" ValidationGroup="CPTCharge" />
                    <div class="Hidden"><asp:TextBox ID="txtCPTChargeID" runat="server" /></div>
                </td>
            </tr>
        </tbody>
    </table>
    <Telerik:RadGrid ID="grdCPTCharges" runat="server" PageSize="10" OnNeedDataSource="grdCPTCharges_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="CPT Code">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate><%# GetCPTCode((TestInvoice_Test_CPTCodes_Custom)Container.DataItem) %></ItemTemplate>
                    <ItemTemplate>
                        <%#
                            IsViewMode
                            ? GetCPTCode((TestInvoice_Test_CPTCodes_Custom)Container.DataItem)
                            : "<a href=\"javascript:EditCPTCharge(" + ((TestInvoice_Test_CPTCodes_Custom)Container.DataItem).ID + ")\">" + GetCPTCode((TestInvoice_Test_CPTCodes_Custom)Container.DataItem) + "</a>"
                        %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Amount">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate><%# ((TestInvoice_Test_CPTCodes_Custom)Container.DataItem).Amount.ToString("c") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Description">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((TestInvoice_Test_CPTCodes_Custom)Container.DataItem).Description.Replace("\n", "<br/>") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Actions">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Wrap="false" Width="100" />
                    <ItemTemplate>
                        <a id="aEdit" runat="server" href='<%# "javascript:EditCPTCharge(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                        <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                        <a id="aDelete" runat="server" href='<%# "javascript:ConfirmDeleteCPTCharge(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                        <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>
    <table class="TotalCPTs FormTable">
        <tbody>
            <tr>
                <th>Total CPTs:</th>
                <td><telerik:RadNumericTextBox ID="txtTotalCTPCharges" runat="server" ReadOnly="true" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
            </tr>
        </tbody>
    </table>

    <div class="Buttons"><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" /> <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" /></div>

    <Telerik:RadAjaxManager ID="radAjaxManager" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="rcbProviderID" EventName="SelectedIndexChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="lnkProviderMoreInfo" />
                    <telerik:AjaxUpdatedControl ControlID="txtAmountToProvider" />
                    <telerik:AjaxUpdatedControl ControlID="rdpProviderDueDate" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="rcbCPTCodeID" EventName="SelectedIndexChanged">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCPTChargeAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                    <Telerik:AjaxUpdatedControl ControlID="grdCPTCharges" />
                    <telerik:AjaxUpdatedControl ControlID="txtTotalCTPCharges" />
                    <telerik:AjaxUpdatedControl ControlID="cvCPTCode" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCPTChargeCancel" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCPTChargeSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                    <Telerik:AjaxUpdatedControl ControlID="grdCPTCharges" />
                    <telerik:AjaxUpdatedControl ControlID="txtTotalCTPCharges" />
                    <telerik:AjaxUpdatedControl ControlID="cvCPTCode" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditCPTCharge" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteCPTCharge" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditCPTCharges" />
                    <Telerik:AjaxUpdatedControl ControlID="grdCPTCharges" />
                    <telerik:AjaxUpdatedControl ControlID="txtTotalCTPCharges" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="txtMRI" EventName="TextChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="txtAmountToProvider" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="txtTestCost" EventName="TextChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="txtAmountToProvider" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="cbxCalculate" EventName="CheckedChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="txtAmountToProvider" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </Telerik:RadAjaxManager>
    <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="ConfirmDeleteCPTCharge" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteCPTChargeClose" />
            <telerik:RadWindow ID="ProviderInformation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
        </Windows>
    </telerik:RadWindowManager>
</asp:Content>