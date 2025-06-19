<%@ Page Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageICDCodes.aspx.cs" Inherits="BMM.ManageICDCodes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteICDCode.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteICDCode.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= hfDeletedID.ClientID %>').val(args.id);
                $('#<%= btnDeleteCode.ClientID %>').click();
            }
            else {
                var radgrid = $find("<%= grdICDCodes.ClientID %>");
                var masterTable = radgrid.get_masterTableView();
                masterTable.rebind();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <h1>ICD Codes</h1>
  <div class="Hidden">
    <asp:HiddenField runat="server" ID="hfID" />
    <asp:HiddenField runat="server" ID="hfDeletedID" />
    <asp:Button ID="btnDeleteCode" runat="server" CssClass="Hidden" OnClick="btnDeleteCode_Click" CausesValidation="false" />
  </div>
  <div id="ManageCPTCodesDiv">
        <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnAdd">
            <table width="790px" class="manageCPTCodesLabel">
                <tr>
                    <td>
                        ICD Code Search:
                    </td>
                    <td>
                        <asp:TextBox ID="txtSearch" runat="server" Width="426px" />
                            <asp:Button ID="btnSearch" runat="server" Text="Search" Width="60px" OnClick="btnSearch_Click" CausesValidation="false" />
                    </td>
                </tr>
                <tr>
                    <td>
                        ICD Code:
                    </td>
                    <td>
                        <div style="padding-bottom: 5px; width: 500px;"><asp:TextBox runat="server" ID="txtICDCode" Width="500px"></asp:TextBox><br /></div>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvICDCode" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtICDCode" ErrorMessage="You must enter an ICD Code to add the code to the grid below." />
                        <asp:CustomValidator ID="cvCPTCode" runat="server" ControlToValidate="txtICDCode" Display="Dynamic" CssClass="ErrorText" onservervalidate="CheckForDuplicates" ErrorMessage="This ICD Code already exists." />
                        <asp:RegularExpressionValidator runat="server" Enabled="false" ID="revICDCode" ControlToValidate="txtICDCode" ValidationExpression="^[0-9a-zA-Z]" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be 5 characters and alphanumeric."/>
                    </td>
                </tr>
                
                <tr style="vertical-align: top;">
                    <td> 
                        Short Description:  
                    </td>
                    <td>
                        <asp:TextBox ID="txtShortDescription" runat="server" TextMode="MultiLine" Width="500px" Height="150px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvDescription" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtShortDescription" ErrorMessage="You must enter a Short Description to add the code to the grid below." />                     
                    </td>
                </tr>
                <tr style="vertical-align: top;">
                    <td>Long Description:</td>
                    <td>
                        <asp:TextBox ID="txtLongDescription" runat="server" TextMode="MultiLine" Width="500px" Height="150px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvLongDescription" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtLongDescription" ErrorMessage="You must enter a Long Description to add the code to the grid below." />                     
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td style="text-align: right;">
                        <div runat="server" id="divAdd" visible="true">
                            <asp:Button ID="btnAdd" runat="server" Text="Add" Width="60px" OnClick="btnSave_Click" CausesValidation="true" />
                        </div>
                        <div runat="server" id="divSaveCancel" visible="false">
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" />&nbsp;&nbsp;
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CausesValidation="true" />
                        </div>
                    </td>
                    <td width="400">&nbsp;</td>
                </tr>
            </table>
        </asp:Panel>
      <div>
          <div class="manageICDCodesLabel">Configured Codes:<div style="float: right;"><asp:Button ID="btnClear" runat="server" Text="Clear Results" OnClick="btnClear_Click" CausesValidation="false" /></div></div>
          <Telerik:RadGrid ID="grdICDCodes" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnItemCommand="grdICDCodes_OnItemCommand" OnNeedDataSource="grdICDCodes_NeedDataSource">
              <MasterTableView>
                  <Columns>
                      <Telerik:GridTemplateColumn HeaderText="ICD Code" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="lnkICDCodes" CommandName="lnkEdit" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" ><%# Eval("Code") %></asp:LinkButton>
                        </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                      <Telerik:GridTemplateColumn HeaderText="Short Description" ItemStyle-Width="400px">
                          <ItemTemplate>
                              <%# GetDescription((string)Eval("ShortDescription")) %>
                          </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                      <Telerik:GridTemplateColumn HeaderText="Actions" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center">
                          <ItemTemplate>
                              <%--<Telerik:RadButton ID="btnView" runat="server" Visible='<%# CurrentUsersPermission.AllowView %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnView" CausesValidation="false" SkinID="btnView" Image-EnableImageButton="true" />
                              <asp:Image ID="imgView_Inactive" Visible='<%# !CurrentUsersPermission.AllowView %>' runat="server" SkinID="imgView_Inactive" ToolTip='<%# GetText("TEXT_USER_DOESNT_HAVE_PERMISSION_TEXT")%>' />--%>
                              <Telerik:RadButton ID="btnEdit" runat="server" Visible='<%# CurrentUsersPermission.AllowEdit %>' CommandArgument='<%#Eval("ID") %>' CommandName="btnEdit" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                              <asp:Image ID="imgEdit_Inactive" Visible='<%# !CurrentUsersPermission.AllowEdit %>' runat="server" SkinID="imgEdit_Inactive" ToolTip='<%# TextUserDoesntHavePermissionText %>' />
                              <%# GetDelete((int)Eval("ID")) %>
                          </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                  </Columns>
                  <PagerStyle Mode="NextPrevAndNumeric" LastPageText="LAST" FirstPageText="FIRST" Position="TopAndBottom" />
              </MasterTableView>
          </Telerik:RadGrid>
      </div>
  </div>

  <telerik:RadWindow ID="rwConfirmDeleteICDCode" runat="server" Modal="true" Width="400px" VisibleStatusbar="false" VisibleTitlebar="false" Height="250px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
