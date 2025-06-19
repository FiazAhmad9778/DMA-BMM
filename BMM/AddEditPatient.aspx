<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddEditPatient.aspx.cs" Inherits="BMM.AddEditPatient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="CSS/ManageAddEdit.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type="text/javascript">
    function CollapseDiv() {
        document.getElementById("imgCollapse").style.display = "none";
        document.getElementById("imgExspand").style.display = "inline";
        document.getElementById("Patient_Content").style.display = "none";
    }

    function ExpandDiv() {
        document.getElementById("imgCollapse").style.display = "inline";
        document.getElementById("imgExspand").style.display = "none";
        document.getElementById("Patient_Content").style.display = "block";
    }

</script>


<h1><asp:Literal ID="litPatientInfo" runat="server"></asp:Literal></h1>

<asp:Panel ID="pnlPatient" runat="server" DefaultButton="btnSubmit">
    <div class="DivFloatLeft" style="width: 500px;">
    <table cellpadding="0" cellspacing="0" class="Form FormPadding">
        <tr>
            <th><label for="<%= txtFirstName.ClientID %>">* First Name:</label></th>
            <td><asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="<%= txtLastName.ClientID %>">* Last Name:</label></th>
            <td><asp:TextBox ID="txtLastName" runat="server"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="<%= txtSSN.ClientID %>">SSN:</label></th>
            <td><asp:TextBox ID="txtSSN" runat="server"></asp:TextBox></td>
            <td><asp:RegularExpressionValidator ID="revSSN" runat="server" ControlToValidate="txtSSN" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Invalid SSN" ValidationExpression="^(\d{3}-\d{2}-\d{4})|\d{9}$"></asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <th><h2>Address</h2></th>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <th><label for="<%= txtStreet.ClientID %>">* Street:</label></th>
            <td><asp:TextBox ID="txtStreet" runat="server"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator ID="rfvStreet" runat="server" ControlToValidate="txtStreet" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="<%= txtAptSuite.ClientID %>">Apt or Suite:</label></th>
            <td><asp:TextBox ID="txtAptSuite" runat="server"></asp:TextBox></td>
            <td></td>
        </tr>
        <tr>
            <th><label for="<%= txtCity.ClientID %>">* City:</label></th>
            <td><asp:TextBox ID="txtCity" runat="server"></asp:TextBox></td>
            <td><asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label>* State:</label></th>
            <td>
                <Telerik:RadComboBox ID="rcbState" runat="server" EmptyMessage="Select" AppendDataBoundItems="true" MaxHeight="250px">
                </Telerik:RadComboBox>
            </td>
            <td><asp:RequiredFieldValidator ID="rfvState" runat="server" InitialValue="" ControlToValidate="rcbState" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label for="<%= txtZipCode.ClientID %>">* Zip Code:</label></th>
            <td><asp:TextBox ID="txtZipCode" runat="server"></asp:TextBox></td>
            <td>
                <asp:RegularExpressionValidator ID="revZipCode" runat="server" ControlToValidate="txtZipCode" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Invalid Zip Code" ValidationExpression="^\d{5}(-\d{4})?$"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="rfvZipCode" runat="server" ControlToValidate="txtZipCode" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <th><label for="<%= txtPhone.ClientID %>">* Phone:</label></th>
            <td><asp:TextBox ID="txtPhone" runat="server"></asp:TextBox></td>
            <td>
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <th><label for="<%= txtWorkPhone.ClientID %>">Work Phone:</label></th>
            <td><asp:TextBox ID="txtWorkPhone" runat="server"></asp:TextBox></td>
            <td></td>
        </tr>
        <tr>
            <th><label>* Date of Birth:</label></th>
            <td><Telerik:RadDatePicker ID="rdpDateOfBirth" runat="server"></Telerik:RadDatePicker></td>
            <td><asp:RequiredFieldValidator ID="rfvDateOfBirth" runat="server" ControlToValidate="rdpDateOfBirth" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th><label>* Status:</label></th>
            <td>
                <Telerik:RadComboBox ID="rcbStatus" runat="server">
                    <Items>
                        <Telerik:RadComboBoxItem Value="1" Text="Active" />
                        <Telerik:RadComboBoxItem Value="0" Text="Inactive" />
                    </Items>
                </Telerik:RadComboBox>
            </td>
            <td><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" InitialValue="" ControlToValidate="rcbStatus" Display="Dynamic" CssClass="ErrorText" ErrorMessage="Required"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <th></th>
            <td colspan="2">
                <div class="Form_Buttons">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"  CausesValidation="false" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Save" OnClick="btnSubmit_Click" CausesValidation="true" />
                    <asp:Button ID="btnCreateInvoice" runat="server" Text="Save & Create Invoice" OnClick="btnCreateInvoice_Click" CausesValidation="true" />
                </div>
            </td>
        </tr>
    </table>
    </div>
    <div class="DivFloatRight" id="divReport" runat="server">
        <div id="Patient_Header">
        <img id="imgCollapse" src="/Images/btn_collapse.png" alt="Collapse" onclick="CollapseDiv()" />
        <img id="imgExspand" src="/Images/btn_expand.png" alt="Expand" onclick="ExpandDiv()" style="display:none" />
        <h2>History of Patient Record Changes</h2></div>
        <div id="Patient_Content">
            <div>
                <Telerik:RadGrid ID="grdPatientInfo" runat="server" Width="425px" AllowPaging="true" PageSize="5" OnNeedDataSource="grdPatientInfo_NeedDataSource">
                    <MasterTableView>
                        <Columns>
                          <telerik:GridDateTimeColumn DataField="DateAdded" HeaderText="Date of Change" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                          </telerik:GridDateTimeColumn>
                          <Telerik:GridTemplateColumn HeaderText="Changed By">
                              <ItemStyle HorizontalAlign="Left" />
                              <ItemTemplate>
                                  <%# Eval("User.FirstName")%> <%# Eval("User.LastName")%>
                              </ItemTemplate>
                          </Telerik:GridTemplateColumn>
                          <Telerik:GridTemplateColumn HeaderText="Information Updated">
                              <ItemStyle HorizontalAlign="Left" />
                              <ItemTemplate>
                                  <%# Eval("InformationUpdated")%>
                              </ItemTemplate>
                          </Telerik:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </Telerik:RadGrid>
            </div>
        </div>
    </div>
</asp:Panel>

</asp:Content>
