<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageAttorneys.aspx.cs" Inherits="BMM.ManageAttorneys" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteAttorney.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteAttorney.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd) {
            var radgrid = $find("<%= grdAttorneys.ClientID %>");
            var masterTable = radgrid.get_masterTableView();
            masterTable.rebind();
        }
        function OnClientKeyPressing(sender, args) {
            if (args.get_domEvent().keyCode == 13 && sender.get_value() != '') {
                var btnSearch = $get("<%= btnSearch.ClientID %>")
                btnSearch.click();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  <h1>Attorneys</h1>

  <div id="ManageAttorneysDiv">
      <div>
        <div class="manageAttorneySubTitle">Search:</div>
        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
            <div id="divSearch">
                <span class="manageAttorneyLabel">Name:&nbsp;</span><Telerik:RadComboBox runat="server" ID="rcbAttorneySearch" AllowCustomText="true" Width="200px" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbAttorneySearch_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
            </div>                
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />                          
        </asp:Panel>
        <div class="btnAdd">
            <asp:Button ID="btnAdd" runat="server" Text="Add Attorney" OnClick="btnAdd_Click" CausesValidation="false" />
        </div>
      </div>
    
      <Telerik:RadGrid ID="grdAttorneys" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnNeedDataSource="grdAttorneys_NeedDataSource" OnItemCommand="grdAttorneys_OnItemCommand">
          <MasterTableView>
              <Columns>
                  <Telerik:GridTemplateColumn HeaderText="Name">
                      <ItemTemplate>
                          <a href="/AddEditAttorney.aspx?id=<%# Eval("ID") %>"><%# Eval("FirstName") %> <%# Eval("LastName") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Firm">
                      <ItemTemplate>
                          <%# Eval("Firm.Name")%>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Address" ItemStyle-Width="175px">
                    <ItemTemplate>
                          <%# GetAddress((BMM_DAL.Attorney)Container.DataItem) %>
                      </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Phone" ItemStyle-Wrap="false">
                      <ItemTemplate>
                          <%#Eval("Phone") %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Email Address">
                      <ItemTemplate>
                          <a href="mailto:<%#Eval("Email") %>"><%#Eval("Email") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Status">
                      <ItemTemplate>
                          <%# (bool)Eval("isActiveStatus") ? "Active" : "Inactive" %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Actions" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <Telerik:RadButton ID="btnView" runat="server" Visible='<%# CurrentUsersPermission.AllowView %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnView" CausesValidation="false" SkinID="btnView" Image-EnableImageButton="true" />
                            <asp:Image ID="imgView_Inactive" Visible='<%# !CurrentUsersPermission.AllowView %>' runat="server" SkinID="imgView_Inactive" ToolTip='<%# TextUserDoesntHavePermissionText %>' />
                            <Telerik:RadButton ID="btnEdit" runat="server" Visible='<%# CurrentUsersPermission.AllowEdit %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnEdit" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                            <asp:Image ID="imgEdit_Inactive" Visible='<%# !CurrentUsersPermission.AllowEdit %>' runat="server" SkinID="imgEdit_Inactive" ToolTip='<%# TextUserDoesntHavePermissionText %>' />
                            <%# GetDelete((int)Eval("ID")) %>
                        </ItemTemplate>
                  </Telerik:GridTemplateColumn>
              </Columns>
          </MasterTableView>
      </Telerik:RadGrid>
  </div>

  <telerik:RadWindow ID="rwConfirmDeleteAttorney" runat="server" Modal="true" VisibleStatusbar="false" VisibleTitlebar="false" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
