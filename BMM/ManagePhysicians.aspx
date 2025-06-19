<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManagePhysicians.aspx.cs" Inherits="BMM.ManagePhysicians" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeletePhysician.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeletePhysician.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd) {
            var radgrid = $find("<%= grdPhysicians.ClientID %>");
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

  <h1>Physicians</h1>

  <div id="ManagePhysiciansDiv">
      <div>
        <div class="managePhysicianSubTitle">Search:</div>
        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
            <div id="divSearch">
                <span class="managePhysicianLabel">Name:&nbsp;</span><Telerik:RadComboBox runat="server" ID="rcbPhysicianSearch" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbPhysicianSearch_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
            </div>                
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />                          
        </asp:Panel>
        <div class="btnAdd">
            <asp:Button ID="btnAdd" runat="server" Text="Add Physician" OnClick="btnAdd_Click" CausesValidation="false" />
        </div>
      </div>
    
      <Telerik:RadGrid ID="grdPhysicians" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnNeedDataSource="grdPhysicians_NeedDataSource" OnItemCommand="grdPhysicians_OnItemCommand">
          <MasterTableView>
              <Columns>
                  <Telerik:GridTemplateColumn HeaderText="Name">
                      <ItemTemplate>
                          <a href="/AddEditPhysician.aspx?id=<%# Eval("ID") %>"><%# Eval("FirstName") %> <%# Eval("LastName") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Address">
                    <ItemTemplate>
                          <%# GetAddress((BMM_DAL.Physician)Container.DataItem) %>
                      </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Phone" ItemStyle-Wrap="false">
                      <ItemTemplate>
                          <%#Eval("Phone") %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Email Address">
                      <ItemTemplate>
                          <a href="mailto:<%#Eval("EmailAddress") %>"><%#Eval("EmailAddress") %></a>
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

  <telerik:RadWindow ID="rwConfirmDeletePhysician" runat="server" Modal="true" Width="400px" VisibleStatusbar="false" VisibleTitlebar="false" Height="250px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>