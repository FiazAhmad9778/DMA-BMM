<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageProviders.aspx.cs" Inherits="BMM.ManageProviders" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteProvider.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteProvider.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd) {
            var radgrid = $find("<%= grdProviders.ClientID %>");
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

  <h1>Providers</h1>

  <div id="ManageProvidersDiv">
      <div>
        <div class="manageProviderSubTitle">Search:</div>
        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
            <div id="divSearch">
                <span class="manageProviderLabel">Name:&nbsp;</span><Telerik:RadComboBox runat="server" ID="rcbProviderSearch" AllowCustomText="true" Width="200px" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbProviderSearch_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
            </div>                
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />                          
        </asp:Panel>
        <div class="btnAdd">
            <asp:Button ID="btnAdd" runat="server" Text="Add Provider" OnClick="btnAdd_Click" CausesValidation="false" />
        </div>
      </div>
    
      <Telerik:RadGrid ID="grdProviders" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnNeedDataSource="grdProviders_NeedDataSource" OnItemCommand="grdProviders_OnItemCommand">
          <MasterTableView>
              <Columns>
                  <Telerik:GridTemplateColumn HeaderText="Name">
                      <ItemTemplate>
                          <a href="/AddEditProvider.aspx?id=<%# Eval("ID") %>"><%# Eval("Name") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Address" ItemStyle-Width="175px">
                    <ItemTemplate>
                          <%# GetAddress((BMM_DAL.Provider)Container.DataItem) %>
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

  <telerik:RadWindow ID="rwConfirmDeleteProvider" runat="server" Modal="true" Width="400px" VisibleStatusbar="false" VisibleTitlebar="false" Height="250px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
