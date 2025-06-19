<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserControl_AttorneyTerms.ascx.cs" Inherits="BMM.Controls.UserControl_AttorneyTerms" %>
<tr>
    <th>
        <h2>Attorney Loan Terms:
<Telerik:RadCodeBlock ID="radCodeBlock" runat="server">
            <script type="text/javascript">
                function DeleteAttorneyTerm(ID) {
                    var oWnd = $find("<%= rwConfirmDeleteAttorneyTerm.ClientID %>");
                    document.getElementById('<%= hdnAttorneyTermId.ClientID %>').value = ID;
                    oWnd.setUrl("Windows/ConfirmDeleteAttorneyTerm.aspx?id=" + ID);
                    oWnd.show();
                }
                function OnClientClose(oWnd, arg) {
                    if (arg.get_argument() == true) {
                        document.getElementById('<%= btnDelete.ClientID %>').click();
                    }
                    else {
                        document.getElementById('<%= hdnAttorneyTermId.ClientID %>').value = "0";
                    }
                }
            </script>
        </Telerik:RadCodeBlock>
      </h2>
    </th>
</tr>

<tr>
        <th><label>Term Type:</label></th>
        <td>
            <asp:Panel ID="pnlTermType" runat="server" DefaultButton="btnAdd">
                    <Telerik:RadComboBox id="rcbTermType"  runat="server">
                        <Items>
                            <Telerik:RadComboBoxItem Text="Test" Value="1" Selected="true" />
                            <Telerik:RadComboBoxItem Text="Surgery" Value="2" />
                        </Items>
                    </Telerik:RadComboBox>
            </asp:Panel>
        </td>
        <th><label>Yearly Interest:</label></th>
        <td>
            <asp:Panel ID="pnlYearlyInterest" runat="server" DefaultButton="btnAdd">
                <telerik:RadNumericTextBox ID="txtYearlyInterest" runat="server" Type="Percent"/>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <th>
        </th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="rcbTermType" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="AT"></asp:RequiredFieldValidator></td>
        <th></th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtYearlyInterest" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="AT"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label>Loan Term (In Months):</label></th>
        <td>
            <asp:Panel ID="pnlLoanTerm" runat="server" DefaultButton="btnAdd">
                <telerik:RadTextBox ID="txtLoanTerm" runat="server" MaxLength="10" InputType="Number" />
            </asp:Panel>
        </td>
        <th><label>Interest Waived (In Months):</label></th>
        <td>
            <asp:Panel ID="pnlServiceFeeWaive" runat="server" DefaultButton="btnAdd">
                <telerik:RadTextBox ID="txtServiceFeeWaive" runat="server" MaxLength="10" InputType="Number" />
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <th></th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtLoanTerm" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="AT"></asp:RequiredFieldValidator></td>
        <th></th>
        <td><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtServiceFeeWaive" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Required" ValidationGroup="AT"></asp:RequiredFieldValidator></td>
    </tr>
    <tr>
        <th><label>Start Date:</label></th>
        <td>
            <Telerik:RadDatePicker runat="server" Visible="true" ID="rdpStartDate" Width="125px"></Telerik:RadDatePicker>
            
        </td>
        <th><label>End Date:</label></th>
        <td>
            <Telerik:RadDatePicker runat="server" Visible="true" ID="rdpEndDate" Width="125px"></Telerik:RadDatePicker>
        </td>
    </tr>
    <tr>
        <th></th>
        <td><asp:RequiredFieldValidator ID="rfvStart" runat="server" ControlToValidate="rdpStartDate" ValidationGroup="AT" Enabled="true" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" /></td>
        <th></th>
        <td><asp:CompareValidator ID="dateCompareValidator" runat="server" ControlToValidate="rdpEndDate"
                        ControlToCompare="rdpStartDate" Operator="GreaterThan" Type="Date" ValidationGroup="AT" CssClass="ErrorText" Display="Dynamic" ErrorMessage="<br/>The second date must be after the first one.">
                    </asp:CompareValidator></td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th></th>
        <td>
            <div class="UserControl_Buttons">
                <asp:Button ID="btnCancel" Text="Cancel" runat="server" CausesValidation="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnAdd" Text="Add" runat="server" CausesValidation="true" ValidationGroup="AT" OnClick="btnAdd_Click" />
            </div>
        </td>
    </tr>
<tr>
        <th></th>
        <td colspan="7">
<div style="padding-top:15px; padding-bottom:5px;">
                <Telerik:RadGrid ID="rgAT" runat="server" AllowPaging="true" PageSize="25" Width="624px" OnItemCommand="grdAT_ItemCommand" OnNeedDataSource="rgAT_NeedDataSource" >
                    <MasterTableView>
                        <Columns>
                           <Telerik:GridTemplateColumn HeaderText="Status">
                              <ItemTemplate>
                                  <%# Eval("Status") %>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Discount Start">
                              <ItemTemplate>
                                  <%# Eval("StartDate","{0:M/d/yyyy}")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Discount End">
                              <ItemTemplate>
                                  <%# Eval("EndDate","{0:M/d/yyyy}")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Type">
                              <ItemTemplate>
                                  <%# Convert.ToInt32(Eval("TermType")) == 1 ? "Test" : "Surgery"%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Yearly Interest" DataType="System.Decimal">
                              <ItemTemplate>
                                  <%# (Convert.ToDecimal(Eval("YearlyInterest")) * 100).ToString("#.##") + " %"%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Loan Terms (In Months)">
                              <ItemTemplate>
                                  <%# Eval("LoanTermsMonths")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Interest Waived Time Period (In Months)">
                              <ItemTemplate>
                                  <%# Eval("ServiceFeeWaivedMonths")%>
                              </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                            <Telerik:GridTemplateColumn HeaderText="Actions" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <Telerik:RadButton ID="btnEdit" runat="server" Visible='true' CommandArgument='<%#Eval("ID") %>' CommandName="Alter" CausesValidation="false" SkinID="btnEdit" Image-EnableImageButton="true" />
                                    
                                   <%#  Eval("Status").ToString() == "(Scheduled)" ? GetDelete(Eval("ID").ToString()) : "&nbsp;" %>
                                </ItemTemplate>
                            </Telerik:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </Telerik:RadGrid>
</div>
<div class="Hidden">
                <asp:HiddenField ID="hdnAttorneyTermId" runat="server" />
                <asp:HiddenField ID="hdnActive" runat="server" />
                <asp:Button ID="btnDelete" runat="server" OnClick="btnDelete_Click" CausesValidation="false" />
            </div>
            
            <telerik:RadWindow ID="rwConfirmDeleteAttorneyTerm" runat="server" Modal="true" Width="300px" VisibleStatusbar="false" VisibleTitlebar="false"
                Height="200px" OnClientClose="OnClientClose" ReloadOnShow="false" BorderStyle="None" ShowContentDuringLoad="false">
            </telerik:RadWindow>
        
        </td>
    </tr>
