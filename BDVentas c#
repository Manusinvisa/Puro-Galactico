using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace albReL
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnConsulta1_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from p in ventas.TProducto
                           select p;

            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();

        }

        protected void btnPro1_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from c in ventas.TCliente
                           select new
                           {
                               ApellidoCliente = c.Apellidos,
                               NombreCliente = c.Nombres      
                           };

        }

        protected void btnPro2_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from v in ventas.TVendedor
                           select new
                           {
                               ApellidoVendedor = v.Apellidos,
                               NombreVendedor = v.Nombres
                           };

            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();

        }

        protected void btnPro3_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from b in ventas.TBoleta
                           select new
                           {
                               FechaBoleta = b.Fecha
                           };

            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();

        }

        protected void btnSeleccion1_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from c in ventas.TCliente
                           select new { c.Apellidos, c.Nombres };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }

        protected void btnSeleccion2_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from p in ventas.TProducto
                           select new { p.Nombre, p.Precio };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }

        protected void btnSeleccion3_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from v in ventas.TVendedor
                           select new { v.Apellidos, v.Nombres };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }

        protected void btnRenombramiento1_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from c in ventas.TCliente
                           select new
                           {
                               ApellidoCliente = c.Apellidos,
                               NombreCliente = c.Nombres
                           };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }

        protected void btnRenombramiento2_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from p in ventas.TProducto
                           select new
                           {
                               ProductoNombre = p.Nombre,
                               ProductoPrecio = p.Precio
                           };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }

        protected void btnRenombramiento3_Click(object sender, EventArgs e)
        {
            BDVentasEntities1 ventas = new BDVentasEntities1();
            var consulta = from b in ventas.TBoleta
                           select new
                           {
                               FechaBoleta = b.Fecha,
                               Anulado = b.Anulado
                           };
            gvConsulta.DataSource = consulta.ToList();
            gvConsulta.DataBind();
        }
    }
}
