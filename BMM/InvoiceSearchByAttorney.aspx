<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="InvoiceSearchByAttorney.aspx.cs" Inherits="BMM.InvoiceSearchByAttorney" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/InvoiceSearch.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
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
        function ViewFirmInfo(id) {
            var oWnd = $find("<%= rwFirmInfo.ClientID %>");
            oWnd.setUrl("/Windows/FirmInfoPopUp.aspx?id=" + id);
            oWnd.show();
        }
        function PrintRadGrid() {
            var previewWnd = window.open('about:blank', '', '', false);
            var sh = '<%= ClientScript.GetWebResourceUrl(grdInvoices.GetType(),String.Format("Telerik.Web.UI.Skins.{0}.Grid.{0}.css",grdInvoices.Skin)) %>';
    var styleStr = "<html><head><link href = '" + sh + "' rel='stylesheet' type='text/css'></link></head>";
    var htmlcontent = styleStr + "<body>" + $find('<%= grdInvoices.ClientID %>').get_element().outerHTML + "</body></html>";
    previewWnd.document.open();
    previewWnd.document.write(htmlcontent);
    previewWnd.document.close();
    previewWnd.print();
    previewWnd.close();
}
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Search By Attorney</h1>
    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
        <table class="Form" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th><label for="<%= rcbAttorneyName.ClientID %>">Name:</label></th>
                    <td><Telerik:RadComboBox ID="rcbAttorneyName" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                        EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbAttorneyName_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" /></td>
                    <td><asp:Button ID="btnSearch" runat="server" Text="Search" CausesValidation="true" OnClick="btnSearch_Click" /></td>                    
                </tr>
            </tbody>
        </table>
        <p class="ErrorText"><asp:Literal ID="litError" runat="server" /></p>
    </asp:Panel>
    <div ID="divResults" runat="server" visible="false">
        <h2>Attorney Information</h2>
        <table class="Info" style="float:left" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th colspan="2"><asp:Literal ID="litAttorneyName" runat="server" /></th>
                </tr>
                <tr>
                    <th>Address:</th>
                    <td><asp:Literal ID="litAddress" runat="server" /></td>
                </tr>
                <tr>
                    <th>Phone:</th>
                    <td><asp:Literal ID="litPhone" runat="server" /></td>
                </tr>
                <tr>
                    <th>Fax:</th>
                    <td><asp:Literal ID="litFax" runat="server" /></td>
                </tr>
                <tr>
                    <th>Email:</th>
                    <td><asp:Literal ID="litEmail" runat="server" /></td>
                </tr>
            </tbody>
        </table>
        <table class="Info" style="float:left" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <th class="Firm">Firm: <asp:Literal ID="litFirmName" runat="server" /></th>
                </tr>
                <tr>
                    <td class="Contacts">
                        <div>Contacts:</div>
                        <Telerik:RadGrid ID="grdContacts" runat="server" AutoGenerateColumns="false">
                            <MasterTableView>
                                <Columns>
                                    <Telerik:GridTemplateColumn HeaderText="Name">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemTemplate><%# Eval("Name") %></ItemTemplate>
                                    </Telerik:GridTemplateColumn>
                                    <Telerik:GridTemplateColumn HeaderText="Position">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemTemplate><%# Eval("Position") %></ItemTemplate>
                                    </Telerik:GridTemplateColumn>
                                    <Telerik:GridTemplateColumn HeaderText="Phone">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemTemplate><%# String.IsNullOrWhiteSpace(Eval("Phone").ToString()) ? "N/A" : Eval("Phone") %></ItemTemplate>
                                    </Telerik:GridTemplateColumn>
                                    <Telerik:GridTemplateColumn HeaderText="Email">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                        <ItemTemplate><%# String.IsNullOrWhiteSpace(Eval("Email").ToString()) ? "N/A" : "<a href=\"mailto:" + Eval("Email").ToString() + "\">" + Eval("Email").ToString() + "</a>" %></ItemTemplate>
                                    </Telerik:GridTemplateColumn>
                                </Columns>
                            </MasterTableView>
                        </Telerik:RadGrid>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="hr"><hr /></div>
        <h2>Invoices Associated with Attorney</h2>
        <Telerik:RadGrid ID="grdInvoices" runat="server" AutoGenerateColumns="false" OnNeedDataSource="grdInvoices_OnNeedDataSource" AllowPaging="true" PageSize="20" Width="600">
            
            <MasterTableView TableLayout="Fixed">
                <Columns>
                    <Telerik:GridTemplateColumn HeaderText="Invoice #">
                        <HeaderStyle HorizontalAlign="Center" Width="100" Wrap="false" />
                        <ItemStyle HorizontalAlign="Center" Width="100" Wrap="false" />
                        <ItemTemplate><a href="AddEditInvoice.aspx?id=<%# Eval("ID") %>"><%# Eval("InvoiceNumber") %></a></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Patient">
                        <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <ItemTemplate><%# Eval("InvoicePatient.LastName") %>, <%# Eval("InvoicePatient.FirstName") %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn HeaderText="Type">
                        <HeaderStyle HorizontalAlign="Center" Width="75" Wrap="false" />
                        <ItemStyle HorizontalAlign="Center" Width="75" Wrap="false" />
                        <ItemTemplate><%# GetInvoiceType((BMM_DAL.Invoice)Container.DataItem) %></ItemTemplate>
                    </Telerik:GridTemplateColumn>
                    <Telerik:GridTemplateColumn UniqueName="Actions" HeaderText="Actions">
                        <HeaderStyle HorizontalAlign="Center" Width="125" Wrap="false" />
                        <ItemStyle HorizontalAlign="Center" Width="125" Wrap="false" />
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
        <telerik:RadButton ID="btnPrint" runat="server" OnClick="btnPrint_Click" Text="Print Grid" />
    </div>
    <telerik:RadWindow ID="rwConfirmDeleteInvoice" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false"
        Height="200px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false">
    </telerik:RadWindow>
    <telerik:RadWindow ID="rwFirmInfo" runat="server" Modal="true" VisibleStatusbar="false" VisibleTitlebar="false"
        OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false" AutoSize="false" >
    </telerik:RadWindow>
</asp:Content>
