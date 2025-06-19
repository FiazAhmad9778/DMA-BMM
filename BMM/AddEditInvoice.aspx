<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditInvoice.aspx.cs" Inherits="BMM.AddEditInvoice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">window.history.forward();</script>
    <style type="text/css">
        table.InvoiceForm 
        {
            margin: 10px 0;
        }
        table.InvoiceForm .Textbox,
        table.InvoiceForm .RadComboBox,
        table.InvoiceForm .RadPicker
        {
            width: 170px !important;
        }
        
        table.PaymentBlock .Textbox {
            width: 170px !important;
        }
        table.InvoiceForm td.Wide .Textbox,
        table.InvoiceForm td.Wide .RadComboBox,
        table.InvoiceForm td.Wide .RadPicker
        {
            width: 225px !important;
        }
        table.InvoiceForm > tbody > tr > th,
        table.InvoiceForm > tbody > tr > td
        {
            vertical-align: top;
            white-space: nowrap;
        }
        table.InvoiceForm > tbody > tr > th,
        table.InvoiceForm > tbody > tr > th > label 
        {
            font-size: 14px;
            font-weight: bold;
        }
        table.InvoiceForm > tbody > tr > th > label 
        {
            display: block;
            padding-top: 2px;
        }
        table.InvoiceForm > tbody > tr > th
        {
            text-align: right;
        }
        table.InvoiceForm > tbody > tr > td
        {
            text-align: left;
            padding-left: 5px;
        }
        table.InvoiceForm > tbody > tr > * + th 
        {
            padding-left: 25px;
        }
        table.InvoiceForm > tbody > tr + tr > th,
        table.InvoiceForm > tbody > tr + tr > td 
        {
            padding-top: 15px;
        }
        table.InvoiceForm > tbody > tr > td.Buttons
        {
            vertical-align: top;
            text-align: right;
            width: 100%;
        }
        table.PatientInfo 
        {
        }
        table.PaymentForm, .PaymentGrid, table.TotalPaid
        {
            clear: left;
        }
        .TotalPaid th 
        {
            font-size: 14px;
            font-weight: bold;
            width: 114px;
            padding: 0;
            text-align: left;
        }
        .TotalPaid td {
            font-size: 14px;
            /*text-align: right;*/
            width: 103px;
            padding: 0;
        }
        table.PaymentForm, .PaymentGrid
        {
            width: 55%;
        }
        table.PaymentBlock
        {
            width: 30%;
            float: right;
            background-color: #E4DFC8;
        }
        /*table.PaymentBlock th
        {
            padding-left: 10px;
        }*/
        table.PaymentBlock td
        {
            padding-right: 10px;
        }
        table.PaymentBlock th,
        table.PaymentBlock td
        {
            padding-top: 15px;
            padding-bottom: 15px;
        }
        table.PaymentBlock > tbody > tr + tr > th,
        table.PaymentBlock > tbody > tr + tr > td
        {
            padding-top: 0;
            padding-bottom: 15px;
        }
        table.PaymentForm .ErrorText
        {
            display: block;
        }
        table.GridHeader 
        {
            width: 100%;
            margin-bottom: 10px;
        }
        table.GridHeader th > *,
        table.GridHeader td > *
        {
            margin-top: 0;
            margin-bottom: 0;
        }
        table.GridHeader td
        {
            text-align: left;
            vertical-align: top;
        }
        table.GridHeader td + td
        {
            text-align: right;
        }
        table.SummaryDates
        {
            background-color: #E4DFC8;
            margin: 10px 0 30px 0;
        }
        table.SummaryDates th
        {
            padding: 10px 5px 10px 10px;
            font-size: 14px;
        }
        table.SummaryDates td
        {
            padding: 10px 10px 10px 0;
            width: 155px;
            font-size: 14px;
        }
        table.SummaryDates td + th
        {
            padding-left: 20px;
        }
        table.SummaryAmounts
        {
            width: 100%;
            margin: 30px 0;
        }
        table.SummaryAmounts th
        {
            vertical-align: bottom;
        }
        table.SummaryAmounts th,
        table.SummaryAmounts td
        {
            width: 155px;
            text-align: left;
            padding-left: 10px;
            font-size: 14px;
        }
        table.SummaryAmounts tr + tr > th
        {
            padding-top: 20px;
        }
        table.SummaryAmounts td
        {
            padding-top: 10px;
            text-align: right;
        }
        table.SummaryAmounts input
        {
            margin: 0;
        }
        table.Comments
        {
            /*margin-top: -22px;*/
            margin-bottom: 10px;
        }
        table.Comments th 
        {
            text-align: left;
            vertical-align: top;
            padding-right: 5px;
            padding-left: 4px;
        }
        table.Comments label 
        {
            font-weight: bold;
        }
        table.Comments .SpellCheck,
        table.Comments .Buttons
        {
            text-align: right;
        }
        table.Comments .SpellCheck
        {
            padding-bottom: 10px;
        }
        table.Comments .SpellCheck .rscLinkImg
        {
            float: right;
        }
        table.Comments .Buttons
        {
            padding-top: 10px;
        }
        table.Comments .Buttons > input,
        table.Comments .Buttons > label
        {
            vertical-align: middle;
        }
        table.Comments .Buttons > label
        {
            margin-right: 15px;
        }
        table.Comments td.Validation
        {
            padding-left: 5px;
            vertical-align: top;
            text-align: left;
        }
        div.Buttons 
        {
            text-align: right;
        }
        
        .InactiveText
        {
            float:right; 
            margin-right:77px; 
            color:Red;
        }
        .InactiveText > div
        {
            color:Red;
        }
        input {
            font-size: 14px !important;
        }
    </style>
    <script type="text/javascript">
        function OnSaveClick() {
            var validators = Page_Validators,
                rfvDateOfAccident, rfvPatient, rfvAttorney,
                isValid;
            for (var i = 0; i < validators.length; i++) {
                if (validators[i].id == '<%= rfvDateOfAccident.ClientID %>') rfvDateOfAccident = validators[i];
                if (validators[i].id == '<%= rfvPatient.ClientID %>') rfvPatient = validators[i];
                if (validators[i].id == '<%= rfvAttorney.ClientID %>') rfvAttorney = validators[i];
            }
            ValidatorValidate(rfvDateOfAccident);
            ValidatorValidate(rfvPatient);
            ValidatorValidate(rfvAttorney);
            isValid = rfvDateOfAccident.isvalid && rfvPatient.isvalid && rfvAttorney.isvalid;
            if (!isValid) {
                $('body').scrollTop(0);
                $('html').scrollTop(0);
            }
        }

        function UpdateInvoiceType() {
            var rcbInvoiceType = $("#<%= rcbInvoiceType.ClientID %>_Input");
            if(rcbInvoiceType.val() == "Testing") {
                $(".TestingOnly").show();
                $(".SurgeryOnly").hide();
            } else {
                $(".SurgeryOnly").show();
                $(".TestingOnly").hide();
            }
        }

        function ViewTest(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnViewTest.ClientID %>').click();
        }
        function ViewSurgery(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnViewSurgery.ClientID %>').click();
        }
        function ViewProvider(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnViewProvider.ClientID %>').click();
        }

        function EditTest(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditTest.ClientID %>').click();
        }
        function EditSurgery(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditSurgery.ClientID %>').click();
        }
        function EditProvider(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditProvider.ClientID %>').click();
        }
        function EditPayment(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditPayment.ClientID %>').click();
        }
        function EditPaymentComment(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditPaymentComment.ClientID %>').click();
        }
        function EditComment(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditComment.ClientID %>').click();
        }

        function SaveInvoicePopup() {
            var oWnd = $find("<%= winSaveInvoice.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmSaveInvoice.aspx");
            oWnd.show();
        }
        function EditLoanTerms() {
            var oWnd = $find("<%= EditLoanTerms.ClientID %>");
            oWnd.setUrl("/Windows/EditInvoiceLoanTerms.aspx?isk=<%= InvoiceSessionKey %>");
            oWnd.show();
        }
        function EditLoanTermsClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnEditLoanTerms.ClientID %>').click();
            }
        }

        function ConfirmDeleteTest(id) {
            var oWnd = $find("<%= ConfirmDeleteTest.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteTestInvoiceTest.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteSurgery(id) {
            var oWnd = $find("<%= ConfirmDeleteSurgery.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteSurgeryInvoiceSurgery.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteProvider(id) {
            var oWnd = $find("<%= ConfirmDeleteProvider.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteSurgeryInvoiceProvider.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeletePayment(id) {
            var oWnd = $find("<%= ConfirmDeletePayment.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteInvoicePayment.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeletePaymentComment(id) {
            var oWnd = $find("<%= ConfirmDeletePaymentComment.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteInvoicePaymentComment.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteComment(id) {
            var oWnd = $find("<%= ConfirmDeleteComment.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteInvoiceComment.aspx?isk=<%= InvoiceSessionKey %>&id=" + id);
            oWnd.show();
        }

        function ConfirmDeleteTestClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteTest.ClientID %>').click();
            }
        }
        function ConfirmDeleteSurgeryClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteSurgery.ClientID %>').click();
            }
        }
        function ConfirmDeleteProviderClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteProvider.ClientID %>').click();
            }
        }
        function ConfirmDeletePaymentClose(window, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= txtID.ClientID %>').val(args.id);
                $('#<%= btnDeletePayment.ClientID %>').click();
            }
        }
        function ConfirmDeletePaymentCommentClose(window, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= txtID.ClientID %>').val(args.id);
                $('#<%= btnDeletePaymentComment.ClientID %>').click();
            }
        }
        function ConfirmDeleteCommentClose(window, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= txtID.ClientID %>').val(args.id);
                $('#<%= btnDeleteComment.ClientID %>').click();
            }
        }
        function PopUpSaveInvoice(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnSaveInvoice.ClientID %>').click();
            }
        }

        // Set focus to the Amount Textbox when the date paid is selected
        function SetPaymentFocus() {
            var t = $find("<%= txtPaymentAmount.ClientID %>");
            t.focus();            
        }

        $(document).ready(function () {           

            // show/hide elements based on the invoice type (surgery/testing)
            UpdateInvoiceType();
            // on checking complete, enable status dropdown
            $('#<%= cbxComplete.ClientID %>').click(function () {
                if ($(this).prop('checked')) {
                    $find('<%= rcbStatus.ClientID %>').enable();
                }
                else {
                    $find('<%= rcbStatus.ClientID %>').findItemByText("Open").select();
                    $find('<%= rcbStatus.ClientID %>').disable();
                }
            });
            $('#AttorneyInfo').click(function () {
                var id = $find('<%= rcbAttorney.ClientID %>').get_value();
                if (id != '') {
                    //if (id == $('#<%= txtAttorneyID.ClientID %>').val()) {
                    //    $find("<%= RadWindowManager.ClientID %>").open("/Windows/AttorneyInfoPopUp.aspx?iaid=" + $('#<%= txtInvoiceAttorneyID.ClientID %>').val(), "AttorneyInformation");
                    //}
                    //else {
                        $find("<%= RadWindowManager.ClientID %>").open("/Windows/AttorneyInfoPopUp.aspx?id=" + id, "AttorneyInformation");
                    //}
                }
            });
            $('#PhysicianInfo').click(function () {
                var id = $find('<%= rcbPhysician.ClientID %>').get_value();
                if (id != '') {
                    if (id == $('#<%= txtPhysicianID.ClientID %>').val()) {
                        $find("<%= RadWindowManager.ClientID %>").open("/Windows/PhysicianInfoPopUp.aspx?ipid=" + $('#<%= txtInvoicePhysicianID.ClientID %>').val(), "PhysicianInformation");
                    }
                    else {
                        $find("<%= RadWindowManager.ClientID %>").open("/Windows/PhysicianInfoPopUp.aspx?id=" + id, "PhysicianInformation");
                    }
                }
            });
            $('#<%= btnChangeLoanTerms.ClientID %>').unbind('click').click(function (event) {
                EditLoanTerms();
                event.preventDefault();
                return false;
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="Hidden">
        <asp:TextBox ID="txtID" runat="server" />
        <asp:TextBox ID="txtAttorneyID" runat="server" />
        <asp:TextBox ID="txtInvoiceAttorneyID" runat="server" />
        <asp:TextBox ID="txtPhysicianID" runat="server" />
        <asp:TextBox ID="txtInvoicePhysicianID" runat="server" />
        <asp:Button ID="btnViewTest" runat="server" OnClick="btnViewTest_Click" CausesValidation="false" />
        <asp:Button ID="btnEditTest" runat="server" OnClick="btnEditTest_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteTest" runat="server" OnClick="btnDeleteTest_Click" CausesValidation="false" />
        <asp:Button ID="btnViewSurgery" runat="server" OnClick="btnViewSurgery_Click" CausesValidation="false" />
        <asp:Button ID="btnEditSurgery" runat="server" OnClick="btnEditSurgery_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteSurgery" runat="server" OnClick="btnDeleteSurgery_Click" CausesValidation="false" />
        <asp:Button ID="btnViewProvider" runat="server" OnClick="btnViewProvider_Click" CausesValidation="false" />
        <asp:Button ID="btnEditProvider" runat="server" OnClick="btnEditProvider_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteProvider" runat="server" OnClick="btnDeleteProvider_Click" CausesValidation="false" />
        <asp:Button ID="btnEditPayment" runat="server" OnClick="btnEditPayment_Click" CausesValidation="false" />
        <asp:Button ID="btnDeletePayment" runat="server" OnClick="btnDeletePayment_Click" CausesValidation="false" />
        <asp:Button ID="btnEditPaymentComment" runat="server" OnClick="btnEditPaymentComment_Click" CausesValidation="false" />
        <asp:Button ID="btnDeletePaymentComment" runat="server" OnClick="btnDeletePaymentComment_Click" CausesValidation="false" />
        <asp:Button ID="btnEditComment" runat="server" OnClick="btnEditComment_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteComment" runat="server" OnClick="btnDeleteComment_Click" CausesValidation="false" />
        <asp:Button ID="btnEditLoanTerms" runat="server" OnClick="btnEditLoanTerms_Click" CausesValidation="false" />
        <asp:Button ID="btnSaveInvoice" runat="server" OnClick="btnSaveInvoice_Click" CausesValidation="false" />
    </div>
    <div id="divInvoiceRecord">
        <h1><asp:Literal ID="litAddEditInvoiceHeader" runat="server" /></h1>
        <table class="InvoiceForm">
            <tbody>
                <tr>
                    <th>Invoice #:</th>
                    <td><asp:Literal ID="litInvoiceNumber" runat="server" /></td>
                    <th><label>Date of Accident:</label></th>
                    <td>
                        <Telerik:RadDatePicker ID="rdpDateOfAccident" runat="server" DateInput-DateFormat="MM/dd/yyyy" />
                        <asp:RequiredFieldValidator ID="rfvDateOfAccident" runat="server" ControlToValidate="rdpDateOfAccident" ErrorMessage="Required" CssClass="ErrorText" />
                    </td>
                    <td rowspan="3" class="Buttons">
                        <asp:Button ID="btnWorksheet" runat="server" OnClick="btnWorksheet_Click" />
                        <asp:Button ID="btnPrint" runat="server" OnClick="btnPrint_Click" Text="Invoice Print Out" />
                        <br/><br/><br/>
                        <asp:Button runat="server" ID="btnChangeLoanTerms" Text="Change Loan Terms"/>
                    </td>
                </tr>
                <tr>
                    <th><label>Invoice Type:</label></th>
                    <td><Telerik:RadComboBox ID="rcbInvoiceType" runat="server" OnClientSelectedIndexChanged="UpdateInvoiceType" Filter="Contains" AllowCustomText="false" /></td>
                    <th><label>Status:</label></th>
                    <td><Telerik:RadComboBox ID="rcbStatus" runat="server" Enabled="false" /> <asp:CheckBox ID="cbxComplete" runat="server" Text="Complete" TextAlign="Right" /></td>
                </tr>
                <tr>
                    <th><label class="TestingOnly" style="display:none">Test Type:</label></th>
                    <td colspan="2"><Telerik:RadComboBox ID="rcbTestType" runat="server" CssClass="TestingOnly" style="display:none"/></td>
                    <th></th>
                </tr>
            </tbody>
        </table>
        <div class="hr"><hr /></div>
    </div>
    <div id="divPatientInformation">
         <h2>Patient Information</h2> 
        <table class="InvoiceForm PatientInfo" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <td colspan="6" style="margin: 0 0 0 0; padding-bottom:0px"><div class="InactiveText"><asp:Literal ID="litAttorneyStatus" runat="server" Text="&nbsp"></asp:Literal></div></td>
                </tr>
                <tr style="padding-top:0px;">
                    <th style="padding-top:0px;"><label>Patient:</label></th>
                    <td colspan="3" class="Wide" style="padding-top:0px;">
                        <Telerik:RadComboBox ID="rcbPatient" runat="server" EmptyMessage="Select" AutoPostBack="true" Filter="Contains" AllowCustomText="false" />&nbsp;<asp:LinkButton ID="lnkUpdatePatientInformation" runat="server" Text="Update&nbsp;Patient&nbsp;Information" OnClick="lnkUpdatePatientInformation_Click" CausesValidation="true" ValidationGroup="UpdatePatient" />
                        <asp:RequiredFieldValidator ID="rfvPatient" runat="server" ControlToValidate="rcbPatient" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        <asp:RequiredFieldValidator ID="rfvPatientForLink" runat="server" ControlToValidate="rcbPatient" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" ValidationGroup="UpdatePatient" />
                    </td>
                    <th style="padding-top:0px;"><label>Attorney:</label></th>
                    <td class="Wide" style="padding-top:0px;">
                        <Telerik:RadComboBox ID="rcbAttorney" runat="server" EmptyMessage="Select" AutoPostBack="true" CausesValidation="false" Filter="Contains" />&nbsp;<a href="javascript:void(0);" id="AttorneyInfo">See&nbsp;More&nbsp;Info</a>
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <th>SSN:</th>
                    <td><asp:Literal ID="litPatientSSN" runat="server" /></td>
                    <th>Phone:</th>
                    <td><asp:Literal ID="litPatientPhone" runat="server" /></td>
                    <th><label>Physician:</label></th>
                    <td class="Wide"><Telerik:RadComboBox ID="rcbPhysician" runat="server" EmptyMessage="Select" Filter="Contains" />&nbsp;<a href="javascript:void(0);" id="PhysicianInfo">See&nbsp;More&nbsp;Info</a></td>
                </tr>
                <tr>
                    <th>Address:</th>
                    <td><asp:Literal ID="litPatientAddress" runat="server" /></td>
                    <th>Work&nbsp;Phone:</th>
                    <td colspan="3"><asp:Literal ID="litPatientWorkPhone" runat="server" /></td>
                </tr>
                <tr>
                    <th>Date&nbsp;of&nbsp;Birth:</th>
                    <td colspan="5"><asp:Literal ID="litPatientDOB" runat="server" /></td>
                </tr>
            </tbody>
        </table>
        <div class="hr"><hr /></div>
    </div>
    <div id="divTests" runat="server" class="TestingOnly">
        <div id="divCannotViewTests" runat="server" class="PermissionNeeded">You do not have permission to view this section.</div>
        <div id="divCanViewTests" runat="server">
            <table class="GridHeader" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr>
                        <td><h2>Tests</h2></td>
                        <td><asp:Button ID="btnAddNewTest" runat="server" Text="Add New Test" OnClick="btnAddNewTest_Click" CausesValidation="true" /></td>
                    </tr>
                </tbody>
            </table>
            <Telerik:RadGrid ID="grdTests" runat="server" AllowPaging="true" PageSize="10" OnNeedDataSource="grdTests_NeedDataSource">
                <MasterTableView TableLayout="Fixed">
                    <Columns>
                        <Telerik:GridTemplateColumn HeaderText="Provider">
                            <HeaderStyle HorizontalAlign="Left" Width="20%" />
                            <ItemStyle HorizontalAlign="Left" Width="20%" />
                            <ItemTemplate><%# GetTestProviderName((TestInvoice_Test_Custom)Container.DataItem) %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Test Name">
                            <HeaderStyle HorizontalAlign="Left" Width="25%" />
                            <ItemStyle HorizontalAlign="Left" Width="25%" />
                            <ItemTemplate><a href="javascript:ViewTest('<%# Eval("ID") %>')"><%# GetTestName((TestInvoice_Test_Custom)Container.DataItem)%></a></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Test Date">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                            <ItemTemplate><%# ((DateTime)Eval("TestDate")).ToString("MM/dd/yyyy")%></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Test Cost">
                            <HeaderStyle HorizontalAlign="Right" Width="10%" />
                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                            <ItemTemplate><%# ((Decimal)Eval("TestCost")).ToString("C") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="PPO Discount">
                            <HeaderStyle HorizontalAlign="Right" Width="10%" />
                            <ItemStyle HorizontalAlign="Right" Width="10%" />
                            <ItemTemplate><%# ((Decimal)Eval("PPODiscount")).ToString("C") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Amount Due to Provider">
                            <HeaderStyle HorizontalAlign="Right" Width="15%" />
                            <ItemStyle HorizontalAlign="Right" Width="15%" />
                            <ItemTemplate><%# ((TestInvoice_Test_Custom)Container.DataItem).AmountToProvider.ToString("c") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Actions">
                            <HeaderStyle HorizontalAlign="Center" Width="10%" />
                            <ItemStyle HorizontalAlign="Center" Width="10%" Wrap="false" />
                            <ItemTemplate>
                                <a href='<%# "javascript:ViewTest(" + Eval("ID") + ")" %>'><asp:Image ID="imgView" runat="server" SkinID="imgView" /></a>
                                <a id="aEdit" runat="server" href='<%# "javascript:EditTest(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceTestsPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                                <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceTestsPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditTest %>' />
                                <a id="aDelete" runat="server" href='<%# "Javascript:ConfirmDeleteTest(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceTestsPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                                <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceTestsPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteTest %>' />
                            </ItemTemplate>
                        </Telerik:GridTemplateColumn>
                    </Columns>
                </MasterTableView>
            </Telerik:RadGrid>
        </div>
        <div class="hr"><hr /></div>
    </div>
    <div id="divSurgeries" runat="server" class="SurgeryOnly">
        <table class="GridHeader" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <td><h2>Surgeries</h2></td>
                    <td><asp:Button ID="btnAddNewSurgery" runat="server" Text="Add New Surgery" OnClick="btnAddNewSurgery_Click" CausesValidation="true" /></td>
                </tr>
            </tbody>
        </table>
        <div id="divCannotViewSurgeries" runat="server" class="PermissionNeeded">You do not have permission to view this section.</div>
        <Telerik:RadGrid ID="grdSurgeries" runat="server" AllowPaging="true" PageSize="10" OnNeedDataSource="grdSurgeries_NeedDataSource">
            <MasterTableView>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Type of Procedure/Surgery">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate><a href="javascript:ViewSurgery('<%# Eval("ID") %>')"><%# GetSurgeryName((SurgeryInvoice_Surgery_Custom)Container.DataItem) %></a></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Date Scheduled">
                        <HeaderStyle HorizontalAlign="Center"  />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate><%# GetSurgeryDate((SurgeryInvoice_Surgery_Custom)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Notes on Procedure">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate><%# ((Eval("Notes") == null) || String.IsNullOrEmpty(Eval("Notes").ToString())) ? "&nbsp;" : Server.HtmlEncode(Eval("Notes").ToString()).Replace("\r", "<br/>") %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Actions">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        <ItemTemplate>
                            <a href='<%# "javascript:ViewSurgery(" + Eval("ID") + ")" %>'><asp:Image ID="imgView" runat="server" SkinID="imgView" /></a>
                            <a id="aEdit" runat="server" href='<%# "javascript:EditSurgery(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceSurgeriesPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                            <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceSurgeriesPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditSurgery %>' />
                            <a id="aDelete" runat="server" href='<%# "Javascript:ConfirmDeleteSurgery(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceSurgeriesPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                            <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceSurgeriesPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteSurgery %>' />
                        </ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </Telerik:RadGrid>
        <div class="hr"><hr /></div>
    </div>
    <div id="divProviders" runat="server" class="SurgeryOnly">
        <table class="GridHeader" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <td><h2>Providers</h2></td>
                    <td><asp:Button ID="btnAddNewProvider" runat="server" Text="Add New Provider" OnClick="btnAddNewProvider_Click" CausesValidation="true" /></td>
                </tr>
            </tbody>
        </table>
        <div id="divCannotViewProviders" runat="server" class="PermissionNeeded">You do not have permission to view this section.</div>
        <Telerik:RadGrid ID="grdProviders" runat="server" AllowPaging="true" PageSize="10" OnNeedDataSource="grdProviders_NeedDataSource">
            <MasterTableView>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Provider">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate><a href="javascript:ViewProvider('<%# Eval("ID") %>')"><%# GetProviderName((SurgeryInvoice_Provider_Custom)Container.DataItem) %></a></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Total Estimated Cost">
                        <HeaderStyle HorizontalAlign="Center"  />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate><%# GetProviderTotalEstimatedCost((SurgeryInvoice_Provider_Custom)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Total Cost">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate><%# GetProviderTotalCost((SurgeryInvoice_Provider_Custom)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Total PPO Discount">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate><%# GetProviderTotalPPODiscount((SurgeryInvoice_Provider_Custom)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Total Amount Due">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate><%# GetProviderTotalAmountDue((SurgeryInvoice_Provider_Custom)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Actions">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        <ItemTemplate>
                            <a href='<%# "javascript:ViewProvider(" + Eval("ID") + ")" %>'><asp:Image ID="imgView" runat="server" SkinID="imgView" /></a>
                            <a id="aEdit" runat="server" href='<%# "javascript:EditProvider(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceProvidersPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                            <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceProvidersPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditProvider %>' />
                            <a id="aDelete" runat="server" href='<%# "Javascript:ConfirmDeleteProvider(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceProvidersPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                            <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceProvidersPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteProvider %>' />
                        </ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </Telerik:RadGrid>
        <div class="hr"><hr /></div>
    </div>
    <div id="divPaymentInformation">
        <h2>Payment Information</h2>
        <div id="divCannotViewPayments" runat="server" class="PermissionNeeded">You do not have permission to view this section.</div>
        <div id="divCanViewPayments" runat="server">
            <table class="InvoiceForm PaymentBlock">
                <tbody>
                    <tr>
                        <th><label>Invoice Closed Date:</label></th>
                        <td><Telerik:RadDatePicker ID="rdpClosedDate" runat="server" Width="200px" /></td>
                    </tr>
                    <tr>
                        <th><label>Date Paid:</label></th>
                        <td><Telerik:RadDatePicker ID="rdpDatePaid" runat="server" Width="200px" /></td>
                    </tr>
                    <tr>
                        <th><label>Interest Waived:</label></th>
                        <td><telerik:RadNumericTextBox ID="txtServiceFeeWaived" runat="server" 
                                AutoPostBack="true" Type="Currency" MinValue="0" 
                                EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" 
                                NumberFormat-KeepTrailingZerosOnFocus="false" CssClass="Numeric Textbox" 
                                EnableTheming="False" /></td>
                    </tr>
                    <tr>
                        <th><label>Principal Waived:</label></th>
                        <td><telerik:RadNumericTextBox ID="txtLossesAmount" runat="server" 
                                AutoPostBack="true" Type="Currency" MinValue="0" 
                                EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" 
                                NumberFormat-KeepTrailingZerosOnFocus="false" CssClass="Numeric Textbox" 
                                EnableTheming="False" /></td>
                    </tr>
                </tbody>
            </table>
            <table class="InvoiceForm PaymentForm" id="tblAddEditPayment" runat="server">
                <tbody>
                    <tr>
                        <th><label>Date Paid:</label></th>
                        <td>
                            <Telerik:RadDatePicker ID="rdpPaymentDate" runat="server" DateInput-DateFormat="MM/dd/yyyy">
                                <ClientEvents OnPopupClosing="SetPaymentFocus" />
                                <DatePopupButton TabIndex="-1" />
                            </Telerik:RadDatePicker>
                            <asp:RequiredFieldValidator ID="rfvPaymentDate" runat="server" ControlToValidate="rdpPaymentDate" ValidationGroup="vgPayment" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        </td>
                        <th><label>Amount:</label></th>
                        <td>
                            <telerik:RadNumericTextBox ID="txtPaymentAmount" runat="server" Type="Currency" 
                                EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" 
                                NumberFormat-KeepTrailingZerosOnFocus="false" CssClass="Numeric Textbox" 
                                EnableTheming="False" />
                            <asp:RequiredFieldValidator ID="rfvPaymentAmount" runat="server" ControlToValidate="txtPaymentAmount" ValidationGroup="vgPayment" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        </td>
                    </tr>
                    <tr>
                        <th><label>Type:</label></th>
                        <td>
                            <Telerik:RadComboBox ID="rcbPaymentType" runat="server" EmptyMessage="Select" />
                            <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server" ControlToValidate="rcbPaymentType" ValidationGroup="vgPayment" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        </td>
                        <th><label>Check No.:</label></th>
                        <td>
                            <asp:TextBox ID="txtPaymentCheckNumber" runat="server" />
                            <asp:RequiredFieldValidator ID="rfvPaymentCheckNumber" runat="server" ControlToValidate="txtPaymentCheckNumber" ValidationGroup="vgPayment" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" class="Buttons">
                            <asp:Button ID="btnPaymentAdd" runat="server" Text="Add" OnClick="btnPaymentAdd_Click" ValidationGroup="vgPayment" />
                            <asp:Button ID="btnPaymentCancel" runat="server" Text="Cancel" OnClick="btnPaymentCancel_Click" CausesValidation="false" />
                            <asp:Button ID="btnPaymentSave" runat="server" Text="Save" OnClick="btnPaymentSave_Click" ValidationGroup="vgPayment" />
                            <div class="Hidden"><asp:TextBox ID="txtPaymentID" runat="server" /></div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <Telerik:RadGrid ID="grdPayments" runat="server" AllowPaging="true" PageSize="10" Width="55%" OnNeedDataSource="grdPayments_NeedDataSource" CssClass="PaymentGrid">
                <MasterTableView>
                    <Columns>
                        <Telerik:GridTemplateColumn HeaderText="Date Paid">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="100" />
                            <ItemTemplate><%# ((DateTime)Eval("DatePaid")).ToString("MM/dd/yyyy") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Amount">
                            <HeaderStyle HorizontalAlign="Right"  />
                            <ItemStyle HorizontalAlign="Right" Width="100" />
                            <ItemTemplate><%# GetPaymentAmountText((BMM_DAL.Payment)Container.DataItem) %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Type">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate><%# GetPaymentType((BMM_DAL.Payment)Container.DataItem) %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Check No.">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <ItemTemplate><%# Eval("CheckNumber")%></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Actions">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Wrap="false" />
                            <ItemTemplate>
                                    <a id="aEdit" runat="server" href='<%# "javascript:EditPayment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoicePaymentInformationPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                                    <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoicePaymentInformationPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditPayment %>' />
                                    <a id="aDelete" runat="server" href='<%# "javascript:ConfirmDeletePayment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoicePaymentInformationPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                                    <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoicePaymentInformationPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeletePayment %>' />
                            </ItemTemplate>
                        </Telerik:GridTemplateColumn>
                    </Columns>
                </MasterTableView>
            </Telerik:RadGrid>
            <table class="TotalPaid" id="tblTotalPaid" runat="server">
                <tbody>
                    <tr>
                        <th>Total Paid:</th>
                        <td><asp:Literal ID="litTotalPaid" runat="server"></asp:Literal></td>
                    </tr>
                </tbody>
            </table>
            <table id="tblAddEditPaymentComments" runat="server" class="Comments" cellpadding="0" cellspacing="0" width="55%">
                <tbody>
                    <tr class="Comment">
                        <td colspan="2" class="SpellCheck"><Telerik:RadSpell ID="RadSpell1" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtPaymentComment" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></td>
                    </tr>
                    <tr>
                        <th><label>Comment:</label></th>
                        <td><telerik:RadTextBox ID="txtPaymentComment" runat="server" TextMode="MultiLine" Width="760px" Height="100px" MaxLength="1000" /></td>
                        <td class="Validation"><asp:RequiredFieldValidator ID="rfvPaymentComment" runat="server" ControlToValidate="txtPaymentComment" ValidationGroup="vgPaymentComment" ErrorMessage="Required" CssClass="ErrorText" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="Buttons">
                            <asp:Button ID="btnPaymentCommentAdd" runat="server" Text="Add" OnClick="btnPaymentCommentAdd_Click" ValidationGroup="vgPaymentComment" />
                            <asp:Button ID="btnPaymentCommentSave" runat="server" Text="Save" OnClick="btnPaymentCommentSave_Click" ValidationGroup="vgPaymentComment" />
                            <asp:Button ID="btnPaymentCommentCancel" runat="server" Text="Cancel" OnClick="btnPaymentCommentCancel_Click" CausesValidation="false" />
                            <div class="Hidden"><asp:TextBox ID="txtPaymentCommentID" runat="server" /></div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <Telerik:RadGrid ID="grdPaymentComments" runat="server" AllowPaging="true" PageSize="10" OnNeedDataSource="grdPaymentComments_NeedDataSource">
                <MasterTableView>
                    <Columns>
                        <Telerik:GridTemplateColumn HeaderText="User">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate><%# GetUserName((BMM_DAL.Comment)Container.DataItem) %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Date and Time">
                            <HeaderStyle HorizontalAlign="Left"  />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate><%# ((DateTime)Eval("DateAdded")).ToString("MM/dd/yyyy hh:mm tt") %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Comment">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate><%# GetPaymentCommentText((BMM_DAL.Comment)Container.DataItem) %></ItemTemplate>
                        </Telerik:GridTemplateColumn>
                        <Telerik:GridTemplateColumn HeaderText="Actions">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Wrap="false" />
                            <ItemTemplate>
                                 <a id="aEdit" runat="server" href='<%# "javascript:EditPaymentComment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoicePaymentInformationPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                                 <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoicePaymentInformationPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditComment %>' />
                                 <a id="aDelete" runat="server" href='<%# "javascript:ConfirmDeletePaymentComment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoicePaymentInformationPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                                 <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoicePaymentInformationPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteComment %>' />
                            </ItemTemplate>
                        </Telerik:GridTemplateColumn>
                    </Columns>
                </MasterTableView>
            </Telerik:RadGrid>
        </div>
        <div class="hr"><hr /></div>
    </div>
    <div id="divSummary" runat="server">
        <h2>Summary</h2>
        <table class="SummaryDates" cellspacing="0" cellpadding="0" style="width: 100%;">
            <tbody>
                <tr>
                    <th>Date Interest Begins:</th>
                    <td><asp:Literal ID="litDateServiceFee" runat="server"></asp:Literal></td>
                    <th>Maturity Date:</th>
                    <td><asp:Literal ID="litDateMaturity" runat="server"></asp:Literal></td>
                    <th>Amortization Date:</th>
                    <td><asp:Literal ID="litDateAmortization" runat="server"></asp:Literal></td>
                </tr>
            </tbody>
        </table>
        <table class="SummaryAmounts" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <th style="text-align: right;">Total Cost of Tests - PPO Discount</th>
                    <th style="text-align: right;">Principal/Deposits Paid:</th>
                    <th style="text-align: right;">Principal Waived:</th>
                    <th style="text-align: right;">Balance Due:</th>
                    <th style="text-align: right;">Interest Due:</th>
                    <th style="text-align: right;">Ending Balance:</th>
                </tr>
                <tr>
                    <td><asp:Literal ID="litCostMinusDiscount" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litPrincipaDeposits" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litDeductions" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litBalanceDue" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litServiceFeeDue" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litEndingBalance" runat="server"></asp:Literal></td>
                </tr>
                <tr>
                    <th style="text-align: right;">+ Total PPO Discount</th>
                    <th style="text-align: right;">Interest Paid:</th>
                    <th style="text-align: right;">Interest Waived:</th>
                    <th colspan="3"></th>
                </tr>
                <tr>
                    <td><asp:Literal ID="litPPODiscount" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litServiceFeeReceived" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litInterestWaived" runat="server"></asp:Literal></td>
                    <td colspan="4"></td>
                </tr>
                <tr>
                    <th style="text-align: right;">= Cost of Tests Before PPO Discount</th>
                    <th></th>
                    <th style="text-align: right;">Cost of Goods Sold:</th>
                    <th style="text-align: right;">Total Revenue: </th>
                    <th style="text-align: right;">Total CPTs:</th>
                    <th></th>
                </tr>
                <tr>
                    <td><asp:Literal ID="litCostBeforePPODiscount" runat="server"></asp:Literal></td>
                    <td></td>
                    <td><asp:Literal ID="litCostOfGoods" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litRevenue" runat="server"></asp:Literal></td>
                    <td><asp:Literal ID="litCPTs" runat="server"></asp:Literal></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
        <div class="hr"><hr /></div>
    </div>
    <div id="divComments">
        <h2>Comments</h2>
        <table id="tblAddEditComments" runat="server" class="Comments" cellpadding="0" cellspacing="0">
            <tbody>
                <tr class="Comment">
                    <td colspan="2" class="SpellCheck"><Telerik:RadSpell ID="spellCheck" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtComment" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></td>
                </tr>
                <tr>
                    <th><label>Comment:</label></th>
                    <td><telerik:RadTextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="760px" Height="100px" MaxLength="1000" /></td>
                    <td class="Validation"><asp:RequiredFieldValidator ID="rfvComment" runat="server" ControlToValidate="txtComment" ValidationGroup="vgComment" ErrorMessage="Required" CssClass="ErrorText" /></td>
                </tr>
                <tr>
                    <td colspan="2" class="Buttons">
                        <asp:CheckBox ID="cbxCommentNotIncludedOnReports" runat="server" Text="Not Included on Reports" TextAlign="Right" Checked="true" />
                        <asp:Button ID="btnCommentAdd" runat="server" Text="Add" OnClick="btnCommentAdd_Click" ValidationGroup="vgComment" />
                        <asp:Button ID="btnCommentSave" runat="server" Text="Save" OnClick="btnCommentSave_Click" ValidationGroup="vgComment" />
                        <asp:Button ID="btnCommentCancel" runat="server" Text="Cancel" OnClick="btnCommentCancel_Click" CausesValidation="false" />
                        <div class="Hidden"><asp:TextBox ID="txtCommentID" runat="server" /></div>
                    </td>
                </tr>
            </tbody>
        </table>
        <Telerik:RadGrid ID="grdComments" runat="server" AllowPaging="true" PageSize="10" OnNeedDataSource="grdComments_NeedDataSource">
            <MasterTableView>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="User">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate><%# GetUserName((BMM_DAL.Comment)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Date and Time">
                        <HeaderStyle HorizontalAlign="Left"  />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate><%# ((DateTime)Eval("DateAdded")).ToString("MM/dd/yyyy hh:mm tt") %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Comment">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate><%# GetCommentText((BMM_DAL.Comment)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate><asp:Image ID="imgFlag" runat="server" SkinID="imgFlag" Visible='<%# !(bool)Eval("isIncludedOnReports") %>' /></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Actions">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        <ItemTemplate>
                             <a id="aEdit" runat="server" href='<%# "javascript:EditComment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceCommentsPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                             <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceCommentsPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditComment %>' />
                             <a id="aDelete" runat="server" href='<%# "javascript:ConfirmDeleteComment(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode && CurrentInvoiceCommentsPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                             <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode || !CurrentInvoiceCommentsPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteComment %>' />
                        </ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </Telerik:RadGrid>
        <div id="divCannotViewComments" runat="server" class="PermissionNeeded">You do not have permission to view this section./div>
        <div class="hr"><hr /></div>
    </div>
    <div id="divButtons" class="Buttons">
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" />
        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CausesValidation="true" OnClientClick="OnSaveClick()"  />
        <asp:Button ID="btnSaveAndClose" runat="server" Text="Save and Close" OnClick="btnSaveAndClose_Click" CausesValidation="true" OnClientClick="OnSaveClick()" />
    </div>
    <Telerik:RadAjaxManager ID="radAjaxManager" runat="server">
        <AjaxSettings>
            <Telerik:AjaxSetting AjaxControlID="rcbAttorney" EventName="SelectedIndexChanged">
               <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="litAttorneyStatus" />
               </UpdatedControls> 
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="rcbPatient" EventName="SelectedIndexChanged">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="litPatientSSN" />
                    <Telerik:AjaxUpdatedControl ControlID="litPatientPhone" />
                    <Telerik:AjaxUpdatedControl ControlID="litPatientAddress" />
                    <Telerik:AjaxUpdatedControl ControlID="litPatientWorkPhone" />
                    <Telerik:AjaxUpdatedControl ControlID="litPatientDOB" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteTest" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="grdTests" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteSurgery" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="grdSurgeries" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteProvider" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="grdProviders" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="divCanViewPayments" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="divCanViewPayments" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentCancel" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="divCanViewPayments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditPayment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="divCanViewPayments" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeletePayment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="divCanViewPayments" />
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentCommentAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditPaymentComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPaymentComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentCommentCancel" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditPaymentComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnPaymentCommentSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditPaymentComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPaymentComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditPaymentComment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditPaymentComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeletePaymentComment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditPaymentComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdPaymentComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCommentAdd" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCommentCancel" EventName="Click">
                <UpdatedControls>   
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnCommentSave" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnEditComment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnDeleteComment" EventName="Click">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="tblAddEditComments" />
                    <Telerik:AjaxUpdatedControl ControlID="grdComments" />
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="txtServiceFeeWaived" EventName="TextChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="txtLossesAmount" EventName="TextChanged">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="btnEditLoanTerms" EventName="Click">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="divSummary" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </Telerik:RadAjaxManager>
    <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="AttorneyInformation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" AutoSize="false" />
            <telerik:RadWindow ID="PhysicianInformation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" AutoSize="false" />
            <telerik:RadWindow ID="EditLoanTerms" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="360px" Width="400px" AutoSize="false" OnClientClose="EditLoanTermsClose" />
            <telerik:RadWindow ID="ConfirmDeleteTest" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteTestClose" />
            <telerik:RadWindow ID="ConfirmDeleteSurgery" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteSurgeryClose" />
            <telerik:RadWindow ID="ConfirmDeleteProvider" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteProviderClose" />
            <telerik:RadWindow ID="ConfirmDeletePayment" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeletePaymentClose" />
            <telerik:RadWindow ID="ConfirmDeletePaymentComment" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeletePaymentCommentClose" />
            <telerik:RadWindow ID="ConfirmDeleteComment" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteCommentClose" />
            <telerik:RadWindow ID="InvoiceSaved" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" NavigateUrl="/Windows/InvoiceSaved.aspx"
                EnableViewState="false" Visible="false" VisibleOnPageLoad="false" />
            <telerik:RadWindow ID="winSaveInvoice" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                OnClientClose="PopUpSaveInvoice" />
        </Windows>
    </telerik:RadWindowManager>
</asp:Content>
