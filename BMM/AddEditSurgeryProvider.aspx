<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditSurgeryProvider.aspx.cs" Inherits="BMM.AddEditSurgeryProvider" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">window.history.forward();</script>
    <style type="text/css">
        #Content h2
        {
            margin: 20px 0 10px 0;
            clear: both;
        }
        #Content textarea
        {
            width: 400px !important;
            height: 100px;
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
            padding: 3px 10px 0 0;
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
            padding-top: 11px;
        }
        #Content table.FormTable > tbody > tr + tr > td 
        {
            padding-top: 8px;
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
        
        #Content .Buttons
        {
            margin-top: 10px;
            text-align: right;
        }
        
        .RadInput > input
        {
            text-align: right;
        }
        
        #Content label {
            font-weight: bold !important;
        }
    </style>
    <script type="text/javascript">
        function EditService(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditService.ClientID %>').click();
        }
        function ConfirmDeleteService(id) {
            var oWnd = $find("<%= ConfirmDeleteService.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteProviderService.aspx?isk=<%= InvoiceSessionKey %>&psk=<%= ProviderSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteServiceClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteService.ClientID %>').click();
            }
        }
        function EditPayment(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditPayment.ClientID %>').click();
        }
        function ConfirmDeletePayment(id) {
            var oWnd = $find("<%= ConfirmDeletePayment.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteProviderPayment.aspx?isk=<%= InvoiceSessionKey %>&psk=<%= ProviderSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeletePaymentClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeletePayment.ClientID %>').click();
            }
        }
        function EditCPTCharge(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditCPTCharge.ClientID %>').click();
        }
        function ConfirmDeleteCPTCharge(id) {
            var oWnd = $find("<%= ConfirmDeleteCPTCharge.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteCPTCharge.aspx?mode=provider&isk=<%= InvoiceSessionKey %>&psk=<%= ProviderSessionKey %>&id=" + id);
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
        <asp:Button ID="btnEditService" runat="server" OnClick="btnEditService_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteService" runat="server" OnClick="btnDeleteService_Click" CausesValidation="false" />
        <asp:Button ID="btnEditPayment" runat="server" OnClick="btnEditPayment_Click" CausesValidation="false" />
        <asp:Button ID="btnDeletePayment" runat="server" OnClick="btnDeletePayment_Click" CausesValidation="false" />
        <asp:Button ID="btnEditCPTCharge" runat="server" OnClick="btnEditCPTCharge_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteCPTCharge" runat="server" OnClick="btnDeleteCPTCharge_Click" CausesValidation="false" />
    </div>

    <h1><asp:Literal ID="litAddEditHeader" runat="server" /></h1>

    <span style="float:right"><asp:Button ID="btnGuarantorAuthorization" runat="server" OnClick="btnGuarantorAuthorization_Click" Text="Guarantor Authorization" /></span>

    <table class="FormTable">
        <tbody>
            <tr>
                <th>Provider:</th>
                <td><telerik:RadComboBox ID="rcbProviderID" runat="server" OnSelectedIndexChanged="rcbProviderID_SelectedIndexChanged" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" AutoPostBack="true" CausesValidation="false" /><asp:RequiredFieldValidator ID="rfvProviderID" runat="server" ControlToValidate="rcbProviderID" Text="<br/>Required" CssClass="ErrorText" Display="Dynamic" /></td>
                <td><a href="javascript:void(0);" id="ProviderInfo">See More Info</a></td>
            </tr>
        </tbody>
    </table>


    <h2>Provider Services:</h2>
    <table class="ProviderServices FormTable" id="tblAddEditServices" runat="server" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>Estimated Cost:</th>
                <td><telerik:RadNumericTextBox ID="txtEstimatedCost" runat="server" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                <th>Cost:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtCost" runat="server" OnTextChanged="txtCost_TextChanged" AutoPostBack="true" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                    <asp:RequiredFieldValidator ID="rfvCost" runat="server" ValidationGroup="Service" ControlToValidate="txtCost" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <th>Discount:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtDiscount" runat="server" ReadOnly="true" Type="Percent" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                </td>
                <td></td>
            </tr>
            <tr>
                <th>PPO Discount:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtPPODiscount" runat="server" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                    <asp:RequiredFieldValidator ID="rfvPPODiscount" runat="server" ValidationGroup="Service" ControlToValidate="txtPPODiscount" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <th>Due Date:</th>
                <td>
                    <telerik:RadDatePicker ID="rdpDueDate" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvDueDate" runat="server" ValidationGroup="Service" ControlToValidate="rdpDueDate" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <th>Amount Due:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtAmountDue" runat="server" Type="Currency" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                </td>
                <th><asp:CheckBox runat="server" ID="cbxCalculate" OnCheckedChanged="cbxCalculate_CheckedChanged" Text="Auto-calculate?" AutoPostBack="true" /></th>
            </tr>
            <tr>
                <th>Account Number:</th>
                <td><telerik:RadTextBox ID="txtAccountNumber" runat="server" MaxLength="50" /></td>
                <td colspan="4" style="text-align:right">
                    <asp:Button ID="btnServiceAdd" runat="server" Text="Add" OnClick="btnServiceAdd_Click" ValidationGroup="Service" />
                    <asp:Button ID="btnServiceCancel" runat="server" Text="Cancel" OnClick="btnServiceCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnServiceSave" runat="server" Text="Save" OnClick="btnServiceSave_Click" ValidationGroup="Service" />
                    <div class="Hidden"><asp:TextBox ID="txtServiceID" runat="server" /></div>
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>
    <Telerik:RadGrid ID="grdServices" runat="server" PageSize="10" AllowPaging="true" OnNeedDataSource="grdServices_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="Estimated Cost">
                    <HeaderStyle HorizontalAlign="Center" Width="125" />
                    <ItemStyle HorizontalAlign="Center" Width="125" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).EstimatedCost.HasValue
                                    ? (IsViewMode ?
                                        ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).EstimatedCost.Value.ToString("c")
                                        : "<a href=\"javascript:EditService(" + ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).ID + ")\">" + ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).EstimatedCost.Value.ToString("c")) + "</a>"
                                    : "&nbsp;" %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Cost">
                    <HeaderStyle HorizontalAlign="Center" Width="85" />
                    <ItemStyle HorizontalAlign="Center" Width="85" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).Cost.ToString("c") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Discount">
                    <HeaderStyle HorizontalAlign="Center" Width="85" />
                    <ItemStyle HorizontalAlign="Center" Width="85" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).Discount.ToString("0.00%") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="PPO Discount">
                    <HeaderStyle HorizontalAlign="Center" Width="110" />
                    <ItemStyle HorizontalAlign="Center" Width="110" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).PPODiscount.ToString("c") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Due Date">
                    <HeaderStyle HorizontalAlign="Center" Width="85" />
                    <ItemStyle HorizontalAlign="Center" Width="85" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).DueDate.ToString("MM/dd/yyyy") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Amount Due">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).AmountDue.ToString("c") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Account Number">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).AccountNumber == String.Empty ? "&nbsp;" : ((SurgeryInvoice_Provider_Service_Custom)Container.DataItem).AccountNumber%></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Actions">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Wrap="false" Width="100" />
                    <ItemTemplate>
                            <a id="aServiceEdit" runat="server" href='<%# "javascript:EditService(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgServiceEdit" runat="server" SkinID="imgEdit" /></a>
                            <asp:Image ID="imgServiceEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                            <a id="aServiceDelete" runat="server" href='<%# "javascript:ConfirmDeleteService(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgServiceDelete" runat="server" SkinID="imgDelete" /></a>
                            <asp:Image ID="imgServiceDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>


    <h2>Payments to Providers:</h2>
    <table class="FormTable" ID="tblPayments" runat="server">
        <tbody>
            <tr>
                <th>Date Paid:</th>
                <td>
                    <telerik:RadDatePicker ID="rdpDatePaid" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvDatePaid" runat="server" ValidationGroup="Payment" ControlToValidate="rdpDatePaid" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <th>Amount:</th>
                <td>
                    <telerik:RadNumericTextBox ID="txtPaymentAmount" runat="server" Type="Currency" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" />
                    <asp:RequiredFieldValidator ID="rfvPaymentAmount" runat="server" ValidationGroup="Payment" ControlToValidate="txtPaymentAmount" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <th>Payment Type:</th>
                <td>
                    <telerik:RadComboBox ID="rcbPaymentType" runat="server" EmptyMessage="Select" />
                    <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server" ValidationGroup="Payment" ControlToValidate="rcbPaymentType" Text="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
            </tr>
            <tr>
                <th>Check No.:</th>
                <td><telerik:RadTextBox ID="txtCheckNumber" runat="server" MaxLength="50" /></td>
                <td colspan="4" style="text-align:right">
                    <asp:Button ID="btnPaymentAdd" runat="server" Text="Add" OnClick="btnPaymentAdd_Click" ValidationGroup="Payment" />
                    <asp:Button ID="btnPaymentCancel" runat="server" Text="Cancel" OnClick="btnPaymentCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnPaymentSave" runat="server" Text="Save" OnClick="btnPaymentSave_Click" ValidationGroup="Payment" />
                    <div class="Hidden"><asp:TextBox ID="txtPaymentID" runat="server" /></div>
                </td>
            </tr>
        </tbody>
    </table>
    <Telerik:RadGrid ID="grdPayments" runat="server" PageSize="10" AllowPaging="true" OnNeedDataSource="grdPayments_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="Date Paid">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem).DatePaid.ToString("MM/dd/yyyy") %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Amount">
                    <HeaderStyle HorizontalAlign="Center"  />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%#
                            IsViewMode
                            ? ((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem).Amount.ToString("c")
                            : "<a href=\"javascript:EditPayment(" + ((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem).ID + ")\">" + ((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem).Amount.ToString("c") + "</a>"
                        %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Payment Type">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# GetPaymentType((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem) %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Check No.">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_Payment_Custom)Container.DataItem).CheckNumber %></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Actions">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Wrap="false" Width="100" />
                    <ItemTemplate>
                        <a id="aPaymentEdit" runat="server" href='<%# "javascript:EditPayment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgPaymentEdit" runat="server" SkinID="imgEdit" /></a>
                        <asp:Image ID="imgPaymentEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                        <a id="aPaymentDelete" runat="server" href='<%# "javascript:ConfirmDeletePayment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgPaymentDelete" runat="server" SkinID="imgDelete" /></a>
                        <asp:Image ID="imgPaymentDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>

    <h2>CPT Charges:</h2>
    <table class="CPTCodes FormTable" id="tblAddEditCPTCharges" runat="server" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>CPT Code:</th>
                <td>
                    <telerik:RadComboBox ID="rcbCPTCodeID" runat="server" AllowCustomText="true" MinFilterLength="3" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" EnableLoadOnDemand="true"
                        OnSelectedIndexChanged="rcbCPTCodeID_SelectedIndexChanged" OnItemsRequested="rcbCPTCodeID_ItemsRequested" AutoPostBack="true" CausesValidation="false" EnableItemCaching="true" />
                    
                    <asp:RequiredFieldValidator ID="rfvCPTCodeID" runat="server" ValidationGroup="CPTCharge" ControlToValidate="rcbCPTCodeID" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
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
    <Telerik:RadGrid ID="grdCPTCharges" runat="server" PageSize="10" AllowPaging="true" OnNeedDataSource="grdCPTCharges_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="CPT Code">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate><%# GetCPTCode((SurgeryInvoice_Provider_CPTCode_Custom)Container.DataItem)%></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Amount">
                    <HeaderStyle HorizontalAlign="Right" Width="100" />
                    <ItemStyle HorizontalAlign="Right" Width="100" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_CPTCode_Custom)Container.DataItem).Amount.ToString("c")%></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Description">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((SurgeryInvoice_Provider_CPTCode_Custom)Container.DataItem).Description.Replace("\n", "<br/>")%></ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Actions">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Wrap="false" Width="100" />
                    <ItemTemplate>
                            <a id="aCPTChargeEdit" runat="server" href='<%# "javascript:EditCPTCharge(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgCPTChargeEdit" runat="server" SkinID="imgEdit" /></a>
                            <asp:Image ID="imgCPTChargeEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                            <a id="aCPTChargeDelete" runat="server" href='<%# "javascript:ConfirmDeleteCPTCharge(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgCPTChargeDelete" runat="server" SkinID="imgDelete" /></a>
                            <asp:Image ID="imgCPTChargeDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>
    <table class="TotalCPTs FormTable" cellpadding="0" cellspacing="0">
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
            <Telerik:AjaxSetting AjaxControlID="rcbProviderID" EventName="SelectedIndexChanged">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                    <Telerik:AjaxUpdatedControl ControlID="grdServices" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="txtCost" EventName="TextChanged">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                </UpdatedControls>
            </Telerik:AjaxSetting>

            <Telerik:AjaxSetting AjaxControlID="btnServiceAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                    <Telerik:AjaxUpdatedControl ControlID="grdServices" />
                    <telerik:AjaxUpdatedControl ControlID="txtTotalCTPCharges" />
                    <telerik:AjaxUpdatedControl ControlID="cvCPTCode" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnServiceCancel" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnServiceSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                    <Telerik:AjaxUpdatedControl ControlID="grdServices" />
                    <telerik:AjaxUpdatedControl ControlID="cvCPTCode" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditService" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteService" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditServices" />
                    <Telerik:AjaxUpdatedControl ControlID="grdServices" />
                </UpdatedControls>
            </Telerik:AjaxSetting>

            <Telerik:AjaxSetting AjaxControlID="btnPaymentAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblPayments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentCancel" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblPayments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditPayment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeletePayment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblPayments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>

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
            <telerik:AjaxSetting AjaxControlID="cbxCalculate" EventName="CheckedChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="txtAmountDue" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </Telerik:RadAjaxManager>



    <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="ConfirmDeleteService" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteServiceClose" />
            <telerik:RadWindow ID="ConfirmDeletePayment" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeletePaymentClose" />
            <telerik:RadWindow ID="ConfirmDeleteCPTCharge" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteCPTChargeClose" />
            <telerik:RadWindow ID="ProviderInformation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
        </Windows>
    </telerik:RadWindowManager>
</asp:Content>