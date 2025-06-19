<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ManagePatients.aspx.cs" Inherits="BMM.ManagePatients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function confirmDelete(ID) {
            var oWnd = $find("<%= rwConfirmDeletePatient.ClientID %>");
            oWnd.setUrl("Windows/ConfirmDeletePatient.aspx?id=" + ID);
            oWnd.show();
        }
        function OnClientClose(oWnd) {
            var radgrid = $find("<%= grdPatients.ClientID %>");
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

  <h1>Patients</h1>

  <div id="ManagePatientsDiv">
      <div>
        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
            <table>
                <tr style="line-height: 33px; margin: 0;">
                    <td valign="bottom" style="padding-bottom: 3px;">
                        <span class="managePatientSubTitle">Search:</span><br />
                        <span class="managePatientLabel">Name:&nbsp;</span>
                        <Telerik:RadComboBox runat="server" ID="rcbPatientSearchName" Width="250px" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbPatientSearchName_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
                        &nbsp;&nbsp;&nbsp;
                    </td> 
                    <td valign="bottom" style="padding-bottom: 3px;">
                        <span class="managePatientLabel">SSN:&nbsp;</span>
                        <Telerik:RadComboBox runat="server" ID="rcbPatientSearchSSN" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" MaxLength="11" OnItemsRequested="rcbPatientSearchSSN_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
                    </td>
                    <td valign="bottom">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />
                    </td>
                </tr>
                <tr style="margin: 0; line-height: 14px;">
                    <td><span class="ErrorText"><asp:Literal ID="litError" runat="server" /></span></td>
                    <td colspan="2" style="padding-left: 33px;">
                        <asp:RegularExpressionValidator ID="revSSN" runat="server" ControlToValidate="rcbPatientSearchSSN" ValidationExpression="^(\d{3})((-)?)(\d{2})((-)?)(\d{4})$" ErrorMessage="Invalid SSN" Display="Dynamic" CssClass="ErrorText" />
                    </td>
                </tr>
            </table>                    
        </asp:Panel>
        <div style="margin: 0; padding: 10px 0 10px 0;"></div>
        <div>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="text-align: left;" class="managePatientLabel">
                        Status:&nbsp;
                        <Telerik:RadComboBox runat="server" ID="rcbStatus" Width="250px" AllowCustomText="false" AutoPostBack="true" OnSelectedIndexChanged="rcbStatus_IndexChanged" CausesValidation="false" >
                            <Items>
                                <Telerik:RadComboBoxItem Text="All" Value="0"/>
                                <Telerik:RadComboBoxItem Text="Active" Value="1"/>
                                <Telerik:RadComboBoxItem Text="Inactive" Value="2"/>
                            </Items>
                        </Telerik:RadComboBox>
                    </td>
                    <td style="text-align: right;">
                        <asp:Button ID="btnAdd" runat="server" Text="Add Patient" OnClick="btnAdd_Click" CausesValidation="false" />
                    </td>
                </tr>
            </table>            
        </div>
      </div>
    
      <Telerik:RadGrid ID="grdPatients" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" OnNeedDataSource="grdPatients_NeedDataSource" OnItemCommand="grdPatients_OnItemCommand">
          <MasterTableView>
              <Columns>
                  <Telerik:GridTemplateColumn HeaderText="Name">
                      <ItemTemplate>
                          <a href="/AddEditPatient.aspx?id=<%# Eval("ID") %>"><%# Eval("FirstName") %> <%# Eval("LastName") %></a>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="SSN" ItemStyle-Width="100px">
                      <ItemTemplate>
                          <%# String.IsNullOrEmpty((String)Eval("SSN")) ? "&nbsp;" : Eval("SSN").ToString().Insert(5, "-").Insert(3, "-") %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridTemplateColumn HeaderText="Address" ItemStyle-Width="175px">
                    <ItemTemplate>
                          <%# GetAddress((BMM_DAL.Patient)Container.DataItem) %>
                      </ItemTemplate>
                  </telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Phone">
                      <ItemTemplate>
                          <%#Eval("Phone") %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <telerik:GridDateTimeColumn DataField="DateOfBirth" HeaderText="Date of Birth" DataFormatString="{0:MM/dd/yyyy}">
                  </telerik:GridDateTimeColumn>
                  <Telerik:GridTemplateColumn HeaderText="Status">
                      <ItemTemplate>
                          <%# (bool)Eval("isActiveStatus") ? "Active" : "Inactive" %>
                      </ItemTemplate>
                  </Telerik:GridTemplateColumn>
                  <Telerik:GridTemplateColumn HeaderText="Actions" ItemStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
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

  <telerik:RadWindow ID="rwConfirmDeletePatient" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false" Height="230px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false"></telerik:RadWindow>

</asp:Content>
