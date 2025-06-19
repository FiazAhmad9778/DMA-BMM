<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="InvoiceSearch.aspx.cs" Inherits="BMM.InvoiceSearch" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/InvoiceSearch.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function ClientPayoffQuotation() {
            var oWnd = $find("<%= rwClientPayoffQuotation.ClientID %>");
            var id = $('#<%= txtPatientId.ClientID %>').val();
            oWnd.setUrl("/Windows/ClientPayoffQuotationPopUp.aspx?id=" + id);
            oWnd.show();
        }

        function ConfirmDelete(id) {
            var oWnd = $find("<%= rwConfirmDeleteInvoice.ClientID %>");
            oWnd.setUrl("/Windows/ConfirmDeleteInvoice.aspx?id=" + id);
            oWnd.show();
        }

        function OnClientClose(window, arg) {
            if (arg.get_argument()) {
                var radgrid = $find("<%= grdInvoices.ClientID %>");
                var masterTable = radgrid.get_masterTableView();
                masterTable.rebind();
            }
        }

        function OnClientKeyPressing(sender, args) {
            if (args.get_domEvent().keyCode == 13 && sender.get_value() != '') {
                $get("<%= btnSearch.ClientID %>").click();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="Hidden">
        <asp:TextBox ID="txtPatientId" runat="server" />
    </div>
    <h1>Invoices</h1>
    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
        <table class="Form" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th><label for="<%= rcbSSN.ClientID %>">SSN:</label></th>
                    <td><Telerik:RadComboBox ID="rcbSSN" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                        EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbSSN_ItemsRequested" MaxLength="11" OnClientKeyPressing="OnClientKeyPressing" /></td>
                    <td><asp:RegularExpressionValidator ID="revSSN" runat="server" ControlToValidate="rcbSSN" ValidationExpression="^(\d{3})((-)?)(\d{2})((-)?)(\d{4})$" ErrorMessage="Invalid SSN" CssClass="ErrorText" /></td>
                </tr>
                <tr>
                    <th><label for="<%= rcbName.ClientID %>">Name:</label></th>
                    <td><Telerik:RadComboBox ID="rcbName" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                        EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbName_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" /></td>
                    <td>&nbsp;</td>                    
                </tr>
                <tr>
                    <th><label for="<%= txtInvoiceNumber.ClientID %>">Invoice Number:</label></th>
                    <td><asp:TextBox ID="txtInvoiceNumber" runat="server" MaxLength="10" /></td>
                    <td><asp:RegularExpressionValidator ID="revInvoiceNumber" runat="server" ControlToValidate="txtInvoiceNumber" ValidationExpression="^\d{1,11}$" ErrorMessage="Invalid Invoice Number" CssClass="ErrorText" /></td>
                </tr>
                <tr>
                    <th><label for="<%= rdpDateOfAccident.ClientID %>">Date of Accident:</label></th>
                    <td><Telerik:RadDatePicker ID="rdpDateOfAccident" runat="server" DateInput-DateFormat="MM/dd/yyyy" ShowPopupOnFocus="true" /></td>
                    <td><span id="DateError" class="ErrorText"></span></td>
                </tr>
                <tr>
                    <th><label for="<%= rdpDateOfBirth.ClientID %>">Date of Birth:</label></th>
                    <td><Telerik:RadDatePicker ID="rdpDateOfBirth" runat="server" DateInput-DateFormat="MM/dd/yyyy" ShowPopupOnFocus="true" /></td>
                    <td><span id="DateError" class="ErrorText"></span></td>
                </tr>
                <tr>
                    <th><label for="<%= rdpDateOfService.ClientID %>">Date of Service:</label></th>
                    <td><Telerik:RadDatePicker ID="rdpDateOfService" runat="server" DateInput-DateFormat="MM/dd/yyyy" ShowPopupOnFocus="true" /></td>
                    <td><span id="DateError" class="ErrorText"></span></td>
                </tr>
                <tr>
                    <th></th>
                    <td class="Buttons"><asp:Button ID="btnSearch" runat="server" Text="Search" CausesValidation="true" OnClick="btnSearch_Click" /></td>
                    <td><a href="/InvoiceSearchByAttorney.aspx">Search by Attorney</a></td>
                </tr>
            </tbody>
        </table>
        <p class="ErrorText"><asp:Literal ID="litError" runat="server" /></p>
    </asp:Panel>
    <div ID="divPatientsList" runat="server" visible="false">
        <h2>Patients</h2>
        <p><asp:Literal ID="litMultiplePatientsWithAccidentDate" runat="server" /></p>
        <ul>
            <asp:Repeater ID="rptPatients" runat="server" OnItemCommand="rptPatients_ItemCommand">
                <ItemTemplate><li><asp:LinkButton runat="server" Text='<%# Eval("DisplayName") %>' CommandArgument='<%# Eval("ID") %>' CausesValidation="false" /></li></ItemTemplate>
            </asp:Repeater>
        </ul>
    </div>
    <div ID="divPatient" runat="server" visible="false">
        <h2>Patient Information</h2>
        <table class="Info" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th colspan="4"><asp:Literal ID="litPatientName" runat="server" /></th>
                </tr>
                <tr>
                    <th>SSN:</th>
                    <td><asp:Literal ID="litSSN" runat="server" /></td>
                    <th>Phone:</th>
                    <td><asp:Literal ID="litPhone" runat="server" /></td>
                </tr>
                <tr>
                    <th>Address:</th>
                    <td><asp:Literal ID="litAddress" runat="server" /></td>
                    <th>Work Phone:</th>
                    <td><asp:Literal ID="litWorkPhone" runat="server" /></td>
                </tr>
                <tr>
                    <th>Date of Birth:</th>
                    <td colspan="3"><asp:Literal ID="litDateOfBirth" runat="server" /></td>
                </tr>
            </tbody>
        </table>
        <h2>Invoices Associated with Patient</h2>
        <div style="overflow:auto">
        <table cellpadding="0" cellspacing="0" class="GridHeader">
            <tbody>
                <tr>
                    <th class="Label"><label for="<%= rcbStatus.ClientID %>">Status:</label></th>
                    <td class="ComboBox"><telerik:RadComboBox ID="rcbStatus" runat="server" Width="200"  AutoPostBack="true" OnSelectedIndexChanged="rcbStatus_SelectedIndexChanged" /></td>

                    <td class="Button"><asp:Button ID="btnClientPayoffQuotation" runat="server" Text="Client Payoff Quoation" CausesValidation="false" OnClientClick="ClientPayoffQuotation(); return false;" /></td>
                    <td class="Button"><asp:Button ID="btnPrintWorksheet" runat="server" Text="Print Worksheets" CausesValidation="false" OnClick="btnPrintWorksheet_Click" /></td>
                    <td class="Button"><asp:Button ID="btnPrintInvoice" runat="server" Text="Print Invoices" CausesValidation="false" OnClick="btnPrintInvoice_Click" /></td>
                    <td class="Button"><asp:Button ID="btnAddNewInvoice" runat="server" Text="Add New Invoice" CausesValidation="false" OnClick="btnAddNewInvoice_Click" /></td>
                </tr>
            </tbody>
        </table>
        </div>
        <Telerik:RadGrid ID="grdInvoices" runat="server" MasterTableView-DataKeyNames="ID" AutoGenerateColumns="false" OnNeedDataSource="grdInvoices_OnNeedDataSource" OnDataBound="grdInvoices_DataBound" AllowPaging="true" PageSize="20" ShowFooter="true">
            <MasterTableView DataKeyNames="ID">
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Invoice #">
                        <HeaderStyle HorizontalAlign="Center" Width="6%" />
                        <ItemStyle HorizontalAlign="Center" Width="6%" />
                        <ItemTemplate><a href="AddEditInvoice.aspx?id=<%# Eval("ID") %>"><%# Eval("InvoiceNumber") %></a></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Accident Date">
                        <HeaderStyle HorizontalAlign="Center" Width="8%" />
                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                        <ItemTemplate><%# ((DateTime)Eval("DateOfAccident")).ToString("MM/dd/yyyy") %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Attorney">
                        <HeaderStyle HorizontalAlign="Left" Width="8%" />
                        <ItemStyle HorizontalAlign="Left" Width="8%" />
                        <ItemTemplate><%# Eval("InvoiceAttorney.LastName")%>, <%# Eval("InvoiceAttorney.FirstName")%></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Service Date">
                        <HeaderStyle HorizontalAlign="Center" Width="8%" />
                        <ItemStyle HorizontalAlign="Center" Width="8%" />
                        <ItemTemplate><%# GetFirstServiceDate((BMM_DAL.Invoice)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Type" UniqueName="Type">
                        <HeaderStyle HorizontalAlign="Left" Width="5%" />
                        <ItemStyle HorizontalAlign="Left" Width="5%" />
                        <ItemTemplate><asp:Literal ID="litType" runat="server" Text ="<%# GetInvoiceType((BMM_DAL.Invoice)Container.DataItem) %>"/></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Status">
                        <HeaderStyle HorizontalAlign="Left" Width="5%" />
                        <ItemStyle HorizontalAlign="Left" Width="5%" />
                        <ItemTemplate><span class="Status<%# GetInvoiceStatus((BMM_DAL.Invoice)Container.DataItem).Replace(" ", "") %>"><%# GetInvoiceStatus((BMM_DAL.Invoice)Container.DataItem) %></span></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <telerik:GridTemplateColumn HeaderText="Cancelled Procedures">
                        <HeaderStyle HorizontalAlign="Center" Width="5%" />
                        <ItemStyle HorizontalAlign="Center" Width="5%" />
                        <ItemTemplate><asp:CheckBox runat="server" Checked='<%# GetInvoiceCancelled((BMM_DAL.Invoice)Container.DataItem) %>' Enabled="false" /></ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Invoice Amount" UniqueName="InvoiceAmount">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litInvoiceAmount" runat="server" Text ="<%# GetInvoiceAmount((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litInvoiceTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Cost of Goods" UniqueName="CostOfGoodsSold">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litCostOfGoodsSold" runat="server" Text ="<%# GetCostOfGoodsSold((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litCostOfGoodsSoldTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="PPO Discount" UniqueName="PPODiscount">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litPPODiscount" runat="server" Text ="<%# GetPPODiscount((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litPPODiscountTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Principal" UniqueName="Principal">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litPrincipal" runat="server" Text ="<%# GetPrincipal((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litPrincipalTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Interest" UniqueName="Interest">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litInterest" runat="server" Text ="<%# GetCumulativeServiceFee((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litInterestTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Balance" UniqueName="Balance">
                        <HeaderStyle HorizontalAlign="Right" Width="8%" />
                        <FooterStyle HorizontalAlign="Right" Width="8%" />
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:Literal ID="litBalance" runat="server" Text ="<%# GetInvoiceBillAmount((BMM_DAL.Invoice)Container.DataItem) %>"/>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Literal ID="litBalanceTotal" runat="server" />
                        </FooterTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Actions">
                        <HeaderStyle HorizontalAlign="Center" Width="7%" />
                        <ItemStyle HorizontalAlign="Center" Width="7%" />
                        <ItemTemplate>
                            <a href='/AddEditInvoice.aspx?id=<%# Eval("ID") %>'><asp:Image ID="imgView" runat="server" SkinID="imgView" /></a>
                            <a id="aEdit" runat="server" href='<%# "/AddEditInvoice.aspx?id=" + Eval("ID") %>' Visible='<%# CurrentInvoicesPermission.AllowEdit %>'><asp:Image ID="imgEdit" runat="server" SkinID="imgEdit" /></a>
                            <asp:Image ID="imgEditInactive" runat="server" SkinID="imgEdit_Inactive" Visible='<%# !CurrentInvoicesPermission.AllowEdit %>' ToolTip='<%# ToolTipTextCannotEditInvoice %>' />
                            <a id="aDelete" runat="server" href='<%# "Javascript:ConfirmDelete(" + Eval("ID") + ")" %>' Visible='<%# CurrentInvoicesPermission.AllowDelete %>'><asp:Image ID="imgDelete" runat="server" SkinID="imgDelete" /></a>
                            <asp:Image ID="imgDeleteInactive" runat="server" SkinID="imgDelete_Inactive" Visible='<%# !CurrentInvoicesPermission.AllowDelete %>' ToolTip='<%# ToolTipTextCannotDeleteInvoice %>' />
                        </ItemTemplate>
                    </Telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </Telerik:RadGrid>
        <%--<table style="margin-top: 20px" cellspacing="0" cellpadding="0" ID="tblInvoicesSubTotal" runat="server">
            <tbody>
                <tr>
                    <th style="width:1200px; text-align: right; font-size: 14px; font-family: Arial">Invoice Sub-Total:</th>
                    <td style="padding-left:10px; width:auto; text-align: right; font-size: 14px; font-family: Arial"><asp:Literal ID="litInvoicesSubTotal" runat="server" /></td>
                </tr>

                <tr>
                    <th style="width:1200px; text-align: right; font-size: 14px; font-family: Arial">Balance Sub-Total:</th>
                    <td style="padding-left:10px; width:auto; text-align: right; font-size: 14px; font-family: Arial"><asp:Literal ID="litInvoicesBalanceSubTotal" runat="server" /></td>
                </tr>
            </tbody>
        </table>--%>
    </div>

    <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="rwClientPayoffQuotation" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
                KeepInScreenBounds="true" Modal="true" AutoSize="false" Height="1388px" Width="1050px">
            </telerik:RadWindow>
            <telerik:RadWindow ID="rwConfirmDeleteInvoice" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false"
                Height="200px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>    
</asp:Content>