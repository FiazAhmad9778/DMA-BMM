<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManageCPTCodes.aspx.cs" Inherits="BMM.ManageCPTCodes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeleteCPTCode.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeleteCPTCode.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd, arg) {
            var args = arg.get_argument()
            if (args.deleted) {
                $('#<%= hfDeletedID.ClientID %>').val(args.id);
                $('#<%= btnDeleteCode.ClientID %>').click();
            }
            else {
                var radgrid = $find("<%= grdCPTCodes.ClientID %>");
                var masterTable = radgrid.get_masterTableView();
                masterTable.rebind();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <h1>CPT Codes</h1>
  <div class="Hidden">
    <asp:HiddenField runat="server" ID="hfID" />
    <asp:HiddenField runat="server" ID="hfDeletedID" />
    <asp:Button ID="btnDeleteCode" runat="server" CssClass="Hidden" OnClick="btnDeleteCode_Click" CausesValidation="false" />
  </div>
  <div id="ManageCPTCodesDiv">
        <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnAdd">
            <table class="manageCPTCodesLabel">
                <tr>
                    <td>
                        CPT Code Search:
                    </td>
                    <td>
                            <asp:TextBox ID="txtSearch" runat="server" Width="440px" />
                            <asp:Button ID="btnSearch" runat="server" Text="Search" Width="60px" OnClick="btnSearch_Click" CausesValidation="false" />
                    </td>
                </tr>
                <tr>
                    <td>
                        CPT Code:
                    </td>
                    <td>
                        <div style="padding-bottom: 5px; width: 500px;"><asp:TextBox runat="server" ID="txtCPTCode" Width="500px"></asp:TextBox><br /></div>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvCPTCode" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtCPTCode" ErrorMessage="You must enter a CPT Code to add the code to the grid below." />
                        <asp:CustomValidator ID="cvCPTCode" runat="server" ControlToValidate="txtCPTCode" Display="Dynamic" CssClass="ErrorText" onservervalidate="CheckForDuplicates" ErrorMessage="This CPT Code already exists." />
                        <asp:RegularExpressionValidator runat="server" ID="revCPTCode" ControlToValidate="txtCPTCode" ValidationExpression="^[0-9a-zA-Z]{5}" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Value entered must be 5 characters and alphanumeric."/>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <div style="float: right;">
                            <Telerik:RadSpell ID="spellCheck" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtDescription" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" />
                        </div>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr style="vertical-align: top;">
                    <td> 
                        Description:  
                    </td>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="500px" Height="150px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" ID="rfvDescription" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtDescription" ErrorMessage="You must enter a Description to add the code to the grid below." />                     
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
          <div class="manageCPTCodesLabel">Configured Codes:<div style="float: right;"><asp:Button ID="btnClear" runat="server" Text="Clear Results" OnClick="btnClear_Click" CausesValidation="false" /></div></div>
          <Telerik:RadGrid ID="grdCPTCodes" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnItemCommand="grdCPTCodes_OnItemCommand" OnNeedDataSource="grdCPTCodes_NeedDataSource">
              <MasterTableView>
                  <Columns>
                      <Telerik:GridTemplateColumn HeaderText="CPT Code" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="lnkCPTCodes" CommandName="lnkEdit" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" ><%# Eval("Code") %></asp:LinkButton>
                        </ItemTemplate>
                      </Telerik:GridTemplateColumn>
                      <Telerik:GridTemplateColumn HeaderText="Description" ItemStyle-Width="400px">
                          <ItemTemplate>
                              <%# GetDescription((string)Eval("Description")) %>
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

  <telerik:RadWindow ID="rwConfirmDeleteCPTCode" runat="server" Modal="true" Width="400px" VisibleStatusbar="false" VisibleTitlebar="false" Height="250px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>