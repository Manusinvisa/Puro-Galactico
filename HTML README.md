<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="albReL.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <p>
      <asp:Button Text="Consulta 1 (Productos)" runat="server" ID="btnConsulta1" OnClick="btnConsulta1_Click" />
  </p>
  <p>
      <asp:Button Text="Clientes (Proyección)" runat="server" ID="btnPro1" OnClick="btnPro1_Click" />
  </p>
  <p>
      <asp:Button Text="Vendedores (Proyección)" runat="server" ID="btnPro2" OnClick="btnPro2_Click" />
  </p>
  <p>
      <asp:Button Text="Boletas (Proyección)" runat="server" ID="btnPro3" OnClick="btnPro3_Click" />
  </p>
  <p>
      <asp:Button Text="Seleccion 1 (Clientes)" runat="server" ID="btnSeleccion1" OnClick="btnSeleccion1_Click" />
  </p>
  <p>
      <asp:Button Text="Seleccion 2 (Productos)" runat="server" ID="btnSeleccion2" OnClick="btnSeleccion2_Click" />
  </p>
  <p>
      <asp:Button Text="Seleccion 3 (Vendedores)" runat="server" ID="btnSeleccion3" OnClick="btnSeleccion3_Click" />
  </p>
  <p>
      <asp:Button Text="Renombramiento 1 (Clientes)" runat="server" ID="btnRenombramiento1" OnClick="btnRenombramiento1_Click" />
  </p>
  <p>
      <asp:Button Text="Renombramiento 2 (Productos)" runat="server" ID="btnRenombramiento2" OnClick="btnRenombramiento2_Click" />
  </p>
  <p>
      <asp:Button Text="Renombramiento 3 (Boletas)" runat="server" ID="btnRenombramiento3" OnClick="btnRenombramiento3_Click" />
  </p>  
  
  <asp:GridView runat="server" ID="gvConsulta"></asp:GridView>
        </div>
    </form>
</body>
</html>
