<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="TestStyles.aspx.cs" Inherits="BMM.TestStyles_BMM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function ShowAttorney(id) {
            var RadWindowManagerID = "<%= RadWindowManager.ClientID %>";            
            $find(RadWindowManagerID).open("/Windows/AttorneyInfoPopUp.aspx?id=" + id, "AttorneyInformationWindow");
        }

        function ShowProvider(id) {
            var RadWindowManagerID = "<%= RadWindowManager.ClientID %>";
            $find(RadWindowManagerID).open("/Windows/ProviderInfoPopUp.aspx?id=" + id, "ProviderInformationWindow");
        }

        function ShowPhysician(id) {
            var RadWindowManagerID = "<%= RadWindowManager.ClientID %>";
            $find(RadWindowManagerID).open("/Windows/PhysicianInfoPopUp.aspx?id=" + id, "PhysicianInformationWindow");
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

    <div>
        <h1><%= Company.LongName %></h1>
        <h2><%= Company.Name %> Styles</h2>

        <Telerik:RadComboBox ID="cboTest" runat="server">
        <Items>
            <Telerik:RadComboBoxItem Text="Test Item 1" />
            <Telerik:RadComboBoxItem Text="Test Item 2" />
            <Telerik:RadComboBoxItem Text="Test Item 3" />
            <Telerik:RadComboBoxItem Text="Test Item 4" />
        </Items>
    </Telerik:RadComboBox> 
    <br /><br />
         <Telerik:RadComboBox ID="RadComboBox1" runat="server" Enabled="false" >
            <Items>
                <Telerik:RadComboBoxItem Text="Test Item 1" />
                <Telerik:RadComboBoxItem Text="Test Item 2" />
                <Telerik:RadComboBoxItem Text="Test Item 3" />
                <Telerik:RadComboBoxItem Text="Test Item 4" />
            </Items>
        </Telerik:RadComboBox>
    <br /> <br />
        <Telerik:RadDatePicker runat="server" ID="RadDatePicker1" EnableEmbeddedSkins="false"></Telerik:RadDatePicker>
        <br />
    
    <asp:RadioButton ID="rdoTest" runat="server" Text="test" Checked="true" GroupName="rdoGroup" />
    <asp:RadioButton ID="RadioButton1" runat="server" Text="test 2" GroupName="rdoGroup" />
    <br /><br />
    <asp:CheckBox ID="chkBox" runat="server" Text="My Test" />
    <br />
    <br />
    <asp:Button ID="btnMine" runat="server" Text="Enabled" />
    <asp:Button ID="Button1" runat="server" Text="Disabled" Enabled="false" />
    <br />
    <br />
        <Telerik:RadGrid ID="grdTest" runat="server" EnableEmbeddedSkins="false" Skin="BMM" AutoGenerateColumns="false" Width="550px">
        <MasterTableView>
            <Columns>
                <Telerik:GridTemplateColumn HeaderText="test">
                    <ItemTemplate>
                        <%#Eval("FName") %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="test">
                    <ItemTemplate>
                        <%#Eval("LName") %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="test">
                    <ItemTemplate>
                        <%#Eval("Address") %>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
                <Telerik:GridTemplateColumn HeaderText="test">
                    <ItemTemplate>
                        <a href="#">Edit</a>
                    </ItemTemplate>
                </Telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </Telerik:RadGrid>
    <div class="hr"><hr /></div>
    <asp:TextBox ID="txtTest" runat="server"></asp:TextBox>
    <br /><br />
    <asp:Image ID="imgCloseButton" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
    <br /><br />
    <asp:Image ID="imgFlag" runat="server" SkinID="imgFlag" AlternateText="Flag!!!" />
    <br /><br />
    <table>
        <tr>
            <td colspan="2">
                <asp:TextBox ID="txtTestArea" runat="server" TextMode="MultiLine" Width="350px" Height="100px">
                    This sentence should not have any spelling errors in it.  This sentence should have two spling erors in it.
                </asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
               The buttons should be right aligned<br /> 
               &nbsp;&nbsp;with the textbox's side and below it.
            </td>
            <td style="text-align: right;">
                <Telerik:RadSpell ID="spellCheck" runat="server" ButtonType="ImageButton" ButtonText=" " FragmentIgnoreOptions="All" ControlToCheck="txtTestArea" DictionaryLanguage="en-us" SupportedLanguages="en-US,English" />
            </td>    
        </tr>
    </table>
    <br /><br />
    <div class="Report_DivHeader">
        <h2>Test</h2>
    </div>
    <div class="Report_DivContent">
        <div>
            <div>
                <a href="#">Attorney Statements</a>
                Some text about the attorney statements
            </div>
            <div>
                <a href="#">Attorney Statements</a>
                Some text about the attorney statements
            </div>
        </div>
    </div>
    <div>
        <br /><br />
        <a href="#" onclick="ShowPhysician(1)">See Pysician Info</a><br /><br />
        <a href="#" onclick="ShowAttorney(4)">See Attorney Info</a><br /><br />
        <a href="#" onclick="ShowProvider(1)">See Providor Info</a><br />
    </div>
    <br /><br />
    </div>

    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
        <div style="line-height: 35px; float:left">
            <span class="manageAttorneyLabel">Name:&nbsp;</span><Telerik:RadComboBox runat="server" ID="rcbAttorneySearch" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true" EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbAttorneySearch_ItemsRequested" OnClientKeyPressing="OnClientKeyPressing" />
        </div>                
        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CausesValidation="false" />                          
    </asp:Panel>

    <br /><br />

    <telerik:RadWindowManager ID="RadWindowManager" runat="server">
        <Windows>
            <telerik:RadWindow ID="AttorneyInformationWindow" runat="server" VisibleStatusbar="false" VisibleTitlebar="false" KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
            <telerik:RadWindow ID="PhysicianInformationWindow" runat="server" VisibleStatusbar="false" VisibleTitlebar="false" KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
            <telerik:RadWindow ID="ProviderInformationWindow" runat="server" VisibleStatusbar="false" VisibleTitlebar="false" KeepInScreenBounds="true" Modal="true" Height="650px" Width="640px" AutoSize="false" />
        </Windows>
    </telerik:RadWindowManager>

</asp:Content>
