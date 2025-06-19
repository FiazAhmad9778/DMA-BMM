<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserControl_Contacts.ascx.cs" Inherits="BMM.Controls.UserControl_Contacts" %>
<tr>
    <th>
        <h2>Contacts:
            <Telerik:RadCodeBlock ID="radCodeBlock" runat="server">
            <script type="text/javascript">
                function DeleteUser(ID) {
                    var oWnd = $find("<%= rwConfirmDeleteUser.ClientID %>");
                    document.getElementById('<%= hdnContactId.ClientID %>').value = ID;
                    oWnd.setUrl("Windows/ConfirmDeleteContact.aspx?id=" + ID);
                    oWnd.show();
                }
                function OnClientClose(oWnd, arg) {
                    if (arg.get_argument() == true) {
                        document.getElementById('<%= btnDelete.ClientID %>').click();
                    }
                    else {
                        document.getElementById('<%= hdnContactId.ClientID %>').value = "0";
                    }
                }
            </script>
            </Telerik:RadCodeBlock>
        </h2>
    </th>
</tr>
    <tr>
        <th><label>Name:</label></th>
        <td>
            <asp:Panel ID="pnlContactName" runat="server" DefaultButton="btnAdd">
            <asp:TextBox ID="txtContactName" runat="server" MaxLength="100"></asp:TextBox>
            </asp:Panel>
        </td>
        <th><label>Position:</label></th>
        <td>
            <asp:Panel ID="pnlContactPosistion" runat="server" DefaultButton="btnAdd">
                <asp:TextBox ID="txtContactPosistion" runat="server" MaxLength="100"></asp:TextBox>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <th>
        </th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtContactName" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="Contact"></asp:RequiredFieldValidator></td>
        <th></th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtContactPosistion" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="Contact"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label>Phone:</label></th>
        <td>
            <asp:Panel ID="pnlContactPhone" runat="server" DefaultButton="btnAdd">
                <asp:TextBox ID="txtContactPhone" runat="server"></asp:TextBox>
            </asp:Panel>
        </td>
        <th><label>Email Address:</label></th>
        <td>
            <asp:Panel ID="pnlContactEmail" runat="server" DefaultButton="btnAdd">
                <asp:TextBox ID="txtContactEmail" runat="server" MaxLength="100"></asp:TextBox>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th></th>
        <td><asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtContactEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Email" ValidationGroup="Contact"></asp:RegularExpressionValidator></td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th></th>
        <td>
            <div class="UserControl_Buttons">
                <asp:Button ID="btnContactCancel" Text="Cancel" runat="server" CausesValidation="false" OnClick="btnContactCancel_Click" />
                <asp:Button ID="btnAdd" Text="Add" runat="server" CausesValidation="true" ValidationGroup="Contact" OnClick="btnAdd_Click" />
            </div>
        </td>
    </tr>
    <tr>
        <th></th>
        <td colspan="5">
            <div style="padding-top:15px; padding-bottom:5px;">
                <Telerik:RadGrid ID="rgContacts" runat="server" AllowPaging="true" PageSize="25" Width="624px" OnItemCommand="grdContacts_ItemCommand" OnNeedDataSource="rgContacts_NeedDataSource" >
                    <MasterTableView>
                        <Columns>
                           <Telerik:GridTemplateColumn HeaderText="Name">
                              <ItemTemplate>
                                  <%# Eval("Name") %>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Position">
                              <ItemTemplate>
                                  <%# Eval("Position")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Phone">
                              <ItemTemplate>
                                  <%# Eval("Phone")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Email">
                              <ItemTemplate>
                                  <%# Eval("Email")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Actions" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <Telerik:RadButton ID="btnEdit" runat="server" Visible='<%# isButtonVisable() %>' CommandArgument='<%#Eval("ID") %>' CommandName="Alter" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                                    <asp:Image ID="imgEdit_Inactive" Visible='<%# !isButtonVisable() %>' runat="server" SkinID="imgEdit_Inactive" ToolTip='You do not have the required user permissions to perform this action.' />
                                    <%# GetDelete(Eval("ID").ToString())%>
                                </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </Telerik:RadGrid>
            </div>
            <div class="Hidden">
                <asp:HiddenField ID="hdnContactId" runat="server" />
                <asp:Button ID="btnDelete" runat="server" OnClick="btnDelete_Click" CausesValidation="false" />
            </div>
            
            <telerik:RadWindow ID="rwConfirmDeleteUser" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false"
                Height="200px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false">
            </telerik:RadWindow>



        </td>
    </tr>