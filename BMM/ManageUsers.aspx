<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="BMM.ManageUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <script type="text/javascript">
     function confirmDelete(ID) {
         var oWnd = $find("<%= rwConfirmDeleteUser.ClientID %>");
         oWnd.setUrl("Windows/ConfirmDeleteUser.aspx?id=" + ID);
         oWnd.show();
     }
     function OnClientClose(oWnd) {
         var radgrid = $find("<%= grdUsers.ClientID %>");
         var masterTable = radgrid.get_masterTableView();
         masterTable.rebind();
     }
 </script>

<h1>Users</h1>

<div id="ManageUsersDiv">
    <div>
        <asp:Button ID="btnAdd" runat="server" Text="Add User" OnClick="btnAdd_Click" CausesValidation="false" />
    </div>
    <Telerik:RadGrid ID="grdUsers" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnItemCommand="grdUsers_OnItemCommand" OnNeedDataSource="grdUsers_NeedDataSource">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="Name">
                    <ItemTemplate>
                      <a href="/AddEditUsers.aspx?id=<%# Eval("ID") %>"> <%# Eval("FirstName") %> <%# Eval("LastName") %> </a>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="Email Address">
                    <ItemTemplate>
                        <%#Eval("Email") %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <telerik:GridDateTimeColumn DataField="DateAdded" HeaderText="Date Added" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                </telerik:GridDateTimeColumn>
                <Telerik:GridTemplateColumn HeaderText="Actions" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <Telerik:RadButton ID="btnView" runat="server" Visible='<%# CurrentUsersPermission.AllowView %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnView" CausesValidation="false" SkinID="btnView" Image-EnableImageButton="true" />
                        <asp:Image ID="imgView_Inactive" Visible='<%# !CurrentUsersPermission.AllowView %>' runat="server" SkinID="imgView_Inactive" ToolTip='<%# ToolTipTextCannotEditComment %>' />
                        <Telerik:RadButton ID="btnEdit" runat="server" Visible='<%# CurrentUsersPermission.AllowEdit %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnEdit" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                        <asp:Image ID="imgEdit_Inactive" Visible='<%# !CurrentUsersPermission.AllowEdit %>' runat="server" SkinID="imgEdit_Inactive" ToolTip='<%# TextUserDoesntHavePermissionText %>' />
                        <%# GetDelete((int)Eval("ID")) %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>

</div>

    <telerik:RadWindow ID="rwConfirmDeleteUser" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false"
        Height="200px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false">
    </telerik:RadWindow>
</asp:Content>
