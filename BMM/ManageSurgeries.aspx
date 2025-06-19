<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageSurgeries.aspx.cs" Inherits="BMM.ManageSurgeries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteProcedure.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteProcedure.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= hfDeletedID.ClientID %>').val(args.id);
                $('#<%= btnDeleteProcedure.ClientID %>').click();
            }
            else {
                var radgrid = $find("<%= grdSurgeries.ClientID %>");
                var masterTable = radgrid.get_masterTableView();
                masterTable.rebind();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <h1>Procedures</h1>
  <div class="Hidden">
    <asp:HiddenField runat="server" ID="hfID"/>
    <asp:HiddenField runat="server" ID="hfDeletedID" />
    <asp:Button ID="btnDeleteProcedure" runat="server" CssClass="Hidden" OnClick="btnDeleteProcedure_Click" CausesValidation="false" />
  </div>
  <div id="ManageSurgeriesDiv">
      <div>
        <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnAdd">
            <table>
                <tr>
                    <td style="width: 160px;">
                        Type of Procedure/Surgery:
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtSurgeriesType" Width="500px" MaxLength="100"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvAddSave" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtSurgeriesType" ErrorMessage="You must enter a Procedure to add it to the grid below." />
                        <asp:CustomValidator ID="cvSurgeriesType" runat="server" ControlToValidate="txtSurgeriesType" Display="Dynamic" CssClass="ErrorText" onservervalidate="CheckForDuplicates" ErrorMessage="This procedure already exists." />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td style="text-align: right;">
                        <div runat="server" id="divAdd" visible="true">
                            <asp:Button ID="btnAddCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false"/>&nbsp;&nbsp;
                            <asp:Button ID="btnAdd" runat="server" Text="Add" Width="60px" OnClick="btnSave_Click" CausesValidation="true" />
                        </div>
                        <div runat="server" id="divSaveCancel" visible="false">
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false"/>&nbsp;&nbsp;
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CausesValidation="true" />
                        </div>
                    </td>
                    <td width="400">&nbsp;</td>
                </tr>
            </table>
        </asp:Panel>
      </div>
      <div>
          <div class="manageSurgeriesLabel">Configured Procedures:</div>
          <Telerik:RadGrid ID="grdSurgeries" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnItemCommand="grdSurgeries_OnItemCommand" OnNeedDataSource="grdSurgeries_NeedDataSource">
              <MasterTableView>
                  <Columns>
                      <Telerik:GridTemplateColumn HeaderText="Procedure/Surgery">
                          <ItemTemplate>
                              <asp:LinkButton runat="server" ID="lnkSurgeries" CommandName="lnkEdit" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" ><%# Eval("Name") %></asp:LinkButton>
                          </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                      <Telerik:GridTemplateColumn HeaderText="Actions" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                          <ItemTemplate>
                              <%--<Telerik:RadButton ID="btnView" runat="server" Visible='<%# CurrentUsersPermission.AllowView %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnView" CausesValidation="false" SkinID="btnView" Image-EnableImageButton="true" />
                              <asp:Image ID="imgView_Inactive" Visible='<%# !CurrentUsersPermission.AllowView %>' runat="server" SkinID="imgView_Inactive" ToolTip='<%# GetText("TEXT_USER_DOESNT_HAVE_PERMISSION_TEXT")%>' />--%>
                              <Telerik:RadButton ID="btnEdit" runat="server" Visible='<%# CurrentUsersPermission.AllowEdit %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnEdit" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                              <asp:Image ID="imgEdit_Inactive" Visible='<%# !CurrentUsersPermission.AllowEdit %>' runat="server" SkinID="imgEdit_Inactive" ToolTip='<%# TextUserDoesntHavePermissionText %>' />
                              <%# GetDelete((int)Eval("ID")) %>
                          </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                  </Columns>
              </MasterTableView>
          </Telerik:RadGrid>
      </div>
  </div>

  <telerik:RadWindow ID="rwConfirmDeleteProcedure" runat="server" Modal="true" Width="400px" VisibleStatusbar="false" VisibleTitlebar="false" Height="250px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
