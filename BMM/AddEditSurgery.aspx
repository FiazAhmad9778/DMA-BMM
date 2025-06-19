<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditSurgery.aspx.cs" Inherits="BMM.AddEditSurgery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">window.history.forward();
        function EditCPTCharge(id) {
            $('#<%= txtID.ClientID %>').val(id);
            $('#<%= btnEditICDCode.ClientID %>').click();
        }
        function ConfirmDeleteCPTCharge(id) {
            var oWnd = $find("<%= ConfirmDeleteICDCode.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteSICDCodes.aspx?tsk=<%= SurgerySessionKey %>&id=" + id);
            oWnd.show();
        }
        function ConfirmDeleteCPTChargeClose(window, arg) {
            if (arg.get_argument()) {
                $('#<%= btnDeleteICDCode.ClientID %>').click();
            }
        }
    </script>

    <style type="text/css">
        #Content > table > tbody > tr > th
        {
            text-align: right;
            vertical-align: top;
            font-size: 14px;
            font-weight: bold;
            padding: 4px 10px 0 0;
        }
        #Content > table > tbody > tr > td
        {
            vertical-align: top;
        }
        #Content > table > tbody > tr + tr > th
        {
            padding-top: 14px;
        }
        #Content > table > tbody > tr + tr > td
        {
            padding-top: 10px;
        }
        #Content > table > tbody > tr > th + td
        {
            width: 165px;
        }
        #Content > table > tbody > tr > td + td 
        {
            padding-left: 5px;
        }
        #Content ul 
        {
            padding: 0; margin: 0;
            list-style: none;
        }
        #Content li
        {
            padding: 0; margin: 0;
            display: inline;
        }
        #Content li + li 
        {
            padding-left: 10px;
        }
        #Content textarea
        {
            width:99%;
            height: 100px;
        }
        #Content .ErrorText
        {
            display: block;
        }
        #Content .Buttons
        {
            float: right;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="Hidden">
        <asp:TextBox ID="txtID" runat="server" />
        <asp:TextBox ID="txtProviderID" runat="server" />
        <asp:TextBox ID="txtInvoiceProviderID" runat="server" />
        <asp:Button ID="btnEditICDCode" runat="server" OnClick="btnEditICDCode_Click" CausesValidation="false" />
        <asp:Button ID="btnDeleteICDCode" runat="server" OnClick="btnDeleteICDCode_Click" CausesValidation="false" />
    </div>
    <h1>Surgery Record</h1>
    <div class="Buttons"><asp:Button ID="btnLetterToPatient" runat="server" OnClick="btnLetterToPatient_Click" Text="Letter to Patient" /></div>
    <table cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>Type of Procedure/Surgery:</th>
                <td>
                    <telerik:RadComboBox ID="rcbSurgeryID" runat="server" OnSelectedIndexChanged="rcbSurgeryID_SelectedIndexChanged" Filter="Contains" AllowCustomText="false" EmptyMessage="Select" />
                    <asp:RequiredFieldValidator ID="rfvSurgeryID" runat="server" ControlToValidate="rcbSurgeryID" Text="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <td><asp:LinkButton ID="lnkAddSurgery" runat="server" Text="Is the procedure you need not listed?<br/>Click here to configure the procedure now." OnClick="lnkAddSurgery_Click" CausesValidation="False" /></td>
            </tr>
            <tr>
                <th>Date Scheduled:</th>
                <td>
                    <telerik:RadDatePicker ID="rdpDateScheduled" runat="server" OnSelectedDateChanged="rdpDateScheduled_SelectedDateChanged" />
                    <asp:RequiredFieldValidator ID="rfvDateScheduled" runat="server" ControlToValidate="rdpDateScheduled" Text="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                </td>
                <td><asp:CheckBox ID="cbxMultipleDates" runat="server" Text="Multiple Dates for Procedure" TextAlign="Right" AutoPostBack="true" OnCheckedChanged="cbxMultipleDates_CheckChanged" /></td>
            </tr>
            <asp:ListView ID="lvAdditionalDates" runat="server" OnItemDataBound="lvAdditionalDates_ItemDataBound">
                <ItemTemplate>
                    <tr>
                        <th>Additional Date:</th>
                        <td><telerik:RadDatePicker ID="rdpAdditionalDate" runat="server" OnSelectedDateChanged="rdpAdditionalDate_SelectedDateChanged" Enabled="<%# !IsViewMode %>" ToolTip=<%# IsViewMode ? ToolTipTextUserDoesntHavePermission : String.Empty %> /></td>
                        <td></td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
            <tr id="trAddAnotherDate" runat="server">
                <th></th>
                <td><asp:LinkButton ID="lnkAddAnotherDate" runat="server" Text="+ Add Another Date" OnClick="lnkAddAnotherDate_Click" /></td>
                <td></td>
            </tr>
            <tr>
                <th></th>
                <td colspan="2">
                    <asp:RadioButtonList ID="rblIsInpatient" runat="server" OnSelectedIndexChanged="rblIsInpatient_SelectedIndexChanged" RepeatLayout="UnorderedList">
                        <asp:ListItem Value="true" Text="Inpatient"/>
                        <asp:ListItem Value="false" Text="Outpatient"/>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <th></th>
                <td colspan="2">
                    <asp:CheckBox runat="server" ID="chkSurgeryCancelled" Text="Cancelled"/>
                </td>
            </tr>
            <tr>
                <td colspan="3" align="right"><Telerik:RadSpell ID="splchkNotes" runat="server" ButtonType="ImageButton" ButtonText="" FragmentIgnoreOptions="All" ControlToCheck="txtNotes" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" /></td>
            </tr>
            <tr>
                <th>Notes on Procedure:</th>
                <td colspan="2"><telerik:RadTextBox ID="txtNotes" runat="server" TextMode="MultiLine" OnTextChanged="txtNotes_TextChanged" MaxLength="1000" Width="450px" /></td>
            </tr>
        </tbody>
    </table>
    <h2>ICD Codes</h2>
    <table class="CPTCodes FormTable" id="tblAddEditICDCodes" runat="server" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <th>ICD Code:</th>
                <td>
                    <telerik:RadComboBox ID="rcbICDCodeID" runat="server" AllowCustomText="true" MinFilterLength="3" EmptyMessage="Select" MarkFirstMatch="true" Filter="Contains" EnableLoadOnDemand="true"
                        OnSelectedIndexChanged="rcbICDCodeID_SelectedIndexChanged" OnItemsRequested="rcbICDCodeID_ItemsRequested" AutoPostBack="true" CausesValidation="false" EnableItemCaching="true" />
                    <asp:RequiredFieldValidator ID="rfvICDCode" runat="server" ValidationGroup="CPTCharge" ControlToValidate="rcbICDCodeID" Text="<br />Required" CssClass="ErrorText" Display="Dynamic" />
                    <asp:CustomValidator ID="cvICDCode" runat="server" CssClass="ErrorText" ControlToValidate="rcbICDCodeID" ValidationGroup="CPTCharge" ErrorMessage="Please select a valid ICD Code." OnServerValidate="rcbICDCodeID_ValidateICDCode"></asp:CustomValidator>
                </td>
                
            </tr>
            
            <tr>
                <th>Description:</th>
                <td colspan="3"><telerik:RadTextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="1000" /></td>
            </tr>
            <tr>
                <td colspan="4" style="text-align:right">
                    <asp:Button ID="btnICDCodeAdd" runat="server" Text="Add" OnClick="btnICDCodeAdd_Click" ValidationGroup="CPTCharge" />
                    <asp:Button ID="btnICDCodeCancel" runat="server" Text="Cancel" OnClick="btnICDCodeCancel_Click" CausesValidation="false" />
                    <div class="Hidden"><asp:TextBox ID="txtICDCodeID" runat="server" /></div>
                </td>
            </tr>
        </tbody>
    </table>
    <Telerik:RadGrid ID="grdICDCode" runat="server" PageSize="10" OnNeedDataSource="grdICDCode_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="ICD Code">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate><%# GetICDCode((BMM_DAL.SurgeryInvoice_Surgery_ICDCode)Container.DataItem) %></ItemTemplate>
                    <ItemTemplate>
                        <%#
                            IsViewMode
                            ? GetICDCode((BMM_DAL.SurgeryInvoice_Surgery_ICDCode)Container.DataItem)
                            : "<a href=\"javascript:EditCPTCharge(" + ((BMM_DAL.SurgeryInvoice_Surgery_ICDCode)Container.DataItem).ID + ")\">" + GetICDCode((BMM_DAL.SurgeryInvoice_Surgery_ICDCode)Container.DataItem) + "</a>"
                        %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Description">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate><%# ((BMM_DAL.SurgeryInvoice_Surgery_ICDCode)Container.DataItem).Description.Replace("\n", "<br/>") %></ItemTemplate>
                </Telerik:GridTemplateColumn>

                <Telerik:GridTemplateColumn HeaderText="Actions">
                    <HeaderStyle HorizontalAlign="Center" Width="100" />
                    <ItemStyle HorizontalAlign="Center" Wrap="false" Width="100" />
                    <ItemTemplate>
                        <a id="aDelete" runat="server" href='<%# "javascript:ConfirmDeleteCPTCharge(" + Eval("ID") + ")" %>' Visible='<%# !IsViewMode %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                        <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# IsViewMode %>' ToolTip='<%# ToolTipTextUserDoesntHavePermission %>' />
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>
    <div class="Buttons"><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" /> <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" /></div>

 <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="ConfirmDeleteICDCode" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="200px" Width="300px" AutoSize="false"
                BorderStyle="None" ShowContentDuringLoad="false" OnClientClose="ConfirmDeleteCPTChargeClose" />
            <telerik:RadWindow ID="ProviderInformation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
        </Windows>
    </telerik:RadWindowManager>
</asp:Content>