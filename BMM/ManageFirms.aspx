<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageFirms.aspx.cs" Inherits="BMM.ManageFirms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteFirm.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteFirm.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd) {
            var radgrid = $find("<%= grdFirms.ClientID %>");
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

  <h1>Firms</h1>

  <div id="ManageFirmsDiv">
      <div>
        <div class="manageFirmSubTitle">Search:</div>
        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
            <div id="divSearch">
                <span class="manageFirmLabel">Name:&nbsp;</span><Telerik:RadComboBox runat="server" ID="rcbFirmSearch" AllowCustomText="true" Width="200px" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbAttorneySearch_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
            </div>                
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />                          
        </asp:Panel>
        <div class="btnAdd">
            <asp:Button ID="btnAdd" runat="server" Text="Add Firm" OnClick="btnAdd_Click" CausesValidation="false" />
        </div>
      </div>
    
      <Telerik:RadGrid ID="grdFirms" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnNeedDataSource="grdFirms_NeedDataSource" OnItemCommand="grdFirms_OnItemCommand">
          <MasterTableView>
              <Columns>
                  <Telerik:GridTemplateColumn HeaderText="Firm">
                      <ItemTemplate>
                          <a href="/AddEditFirm.aspx?id=<%# Eval("ID") %>"><%# Eval("Name") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Address">
                    <ItemTemplate>
                          <%# GetAddress((BMM_DAL.Firm)Container.DataItem) %>
                      </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Phone" ItemStyle-Wrap="false" >
                      <ItemTemplate>
                          <%#Eval("Phone") %>
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

  <telerik:RadWindow ID="rwConfirmDeleteFirm" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false" Height="225px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
