
import com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JOptionPane;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author usuario
 */
public class AccesoBD extends javax.swing.JFrame {

    Connection conexion;
    Statement sentencia;
    boolean correcto = true;
    /**
     * Creates new form AccesoBD
     */
    public AccesoBD() {
        initComponents();
        PrepararBaseDatos();
    }
    
    void PrepararBaseDatos()
    {
    
        
        try
        {
            //1.- Cargar el controlador
            String controlador="com.mysql.jdbc.Driver";
            Class.forName(controlador).newInstance();
            
            //2.- Crear el objeto conexión.
            String DBURL="jdbc:mysql://localhost/manempsa";
            String usuario="root";
            String password="";
            
            conexion = DriverManager.getConnection(DBURL,usuario,password);
            
            //3.- Crear el objeto sentencia.
            sentencia = conexion.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
        }
        catch (SQLException ex)
        {
            JOptionPane.showMessageDialog(rootPane, "No se ha podido conectar a la base de datos, comprueba que esté activa (activar XAMP)", "Error al iniciar la aplicación", WIDTH, null);
            correcto = false;
        }
        catch (Exception ex)
        {
            JOptionPane.showMessageDialog(null,"Error al cargar el controlador.");
        }     
}

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        txtArea = new javax.swing.JTextArea();
        btnVerTrab = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        txtSueldo = new javax.swing.JTextField();
        btnigual = new javax.swing.JButton();
        btnMayor = new javax.swing.JButton();
        btnMenor = new javax.swing.JButton();
        txtNombre = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        btnIguala = new javax.swing.JButton();
        btnContienea = new javax.swing.JButton();
        txtDia = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        txtMes = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        txtAno = new javax.swing.JTextField();
        btnAnterior = new javax.swing.JButton();
        btnPosterior = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowActivated(java.awt.event.WindowEvent evt) {
                formWindowActivated(evt);
            }
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        txtArea.setColumns(20);
        txtArea.setRows(5);
        jScrollPane1.setViewportView(txtArea);

        btnVerTrab.setText("Ver datos trabajador");
        btnVerTrab.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnVerTrabActionPerformed(evt);
            }
        });

        jLabel1.setText("Sueldo:");

        btnigual.setText("Igual");
        btnigual.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnigualActionPerformed(evt);
            }
        });

        btnMayor.setText("Mayor que");
        btnMayor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnMayorActionPerformed(evt);
            }
        });

        btnMenor.setText("Menor que");
        btnMenor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnMenorActionPerformed(evt);
            }
        });

        jLabel2.setText("Nombre:");

        btnIguala.setText("Igual a");
        btnIguala.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnIgualaActionPerformed(evt);
            }
        });

        btnContienea.setText("Contiene a");
        btnContienea.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnContieneaActionPerformed(evt);
            }
        });

        jLabel3.setText("Fecha:");

        jLabel4.setText("/");

        jLabel5.setText("/");

        btnAnterior.setText("Anterior");
        btnAnterior.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnAnteriorActionPerformed(evt);
            }
        });

        btnPosterior.setText("Posterior");
        btnPosterior.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnPosteriorActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(btnVerTrab, javax.swing.GroupLayout.PREFERRED_SIZE, 193, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(txtSueldo, javax.swing.GroupLayout.PREFERRED_SIZE, 76, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(btnigual)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(btnMayor)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(btnMenor))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(txtNombre, javax.swing.GroupLayout.PREFERRED_SIZE, 76, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(btnIguala)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(btnContienea))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(txtDia, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel4)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(txtMes, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel5)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(txtAno, javax.swing.GroupLayout.PREFERRED_SIZE, 51, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(btnAnterior)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(btnPosterior)))
                        .addGap(0, 9, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 217, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnVerTrab, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(24, 24, 24)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(txtSueldo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnigual)
                    .addComponent(btnMayor)
                    .addComponent(btnMenor))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(txtNombre, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnIguala)
                    .addComponent(btnContienea))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(txtDia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel4)
                        .addComponent(txtMes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(txtAno, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(btnAnterior)
                                .addComponent(btnPosterior)))))
                .addContainerGap(11, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        try
        {
            conexion.close();
        }
        catch(Exception e)
        {
            JOptionPane.showMessageDialog(rootPane, "No se puede cerrar la base de datos");
        }
    }//GEN-LAST:event_formWindowClosing

    private void formWindowActivated(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowActivated
        if(!correcto)
        {
            this.dispose();
        }
    }//GEN-LAST:event_formWindowActivated

    private void btnVerTrabActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnVerTrabActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        try
        {
            ResultSet r = sentencia.executeQuery("select * from trabajadores order by sueldo");
            r.beforeFirst();

            while(r.next())
            {
                nom = r.getString("nombre");
                ape = r.getString("apellido");
                sueldo = r.getString("sueldo");
                fecha = r.getString("fecha");
                fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);
                
                info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
            }

            txtArea.setText("");
            txtArea.setText(info);

        }
        catch (SQLException ex)
        {
            JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores" + ex);
        }
    }//GEN-LAST:event_btnVerTrabActionPerformed

    private void btnigualActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnigualActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtSueldo.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce un sueldo");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where sueldo = " + txtSueldo.getText());
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (MySQLSyntaxErrorException ex)
            {
                JOptionPane.showMessageDialog(null,"El sueldo debe ser un número");
            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores" + ex);
            }
        }
    }//GEN-LAST:event_btnigualActionPerformed

    private void btnMayorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnMayorActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtSueldo.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce un sueldo");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where sueldo > " + txtSueldo.getText());
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (MySQLSyntaxErrorException ex)
            {
                JOptionPane.showMessageDialog(null,"El sueldo debe ser un número");
            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores" + ex);
            }
        }
    }//GEN-LAST:event_btnMayorActionPerformed

    private void btnMenorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnMenorActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtSueldo.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce un sueldo");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where sueldo < " + txtSueldo.getText());
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (MySQLSyntaxErrorException ex)
            {
                JOptionPane.showMessageDialog(null,"El sueldo debe ser un número");
            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores" + ex);
            }
        }
    }//GEN-LAST:event_btnMenorActionPerformed

    private void btnIgualaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnIgualaActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtNombre.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce un nombre");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where nombre = '" + txtNombre.getText() + "'");
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores " + ex);
            }
        }
    }//GEN-LAST:event_btnIgualaActionPerformed

    private void btnContieneaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnContieneaActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtNombre.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce un nombre");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where nombre like '%" + txtNombre.getText() + "%'");
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores " + ex);
            }
        }
    }//GEN-LAST:event_btnContieneaActionPerformed

    private void btnAnteriorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnAnteriorActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtDia.getText().isEmpty() || txtMes.getText().isEmpty() || txtAno.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce una fecha");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where fecha < '" + txtAno.getText() + "-" + txtMes.getText() + "-" + txtDia.getText() + "'");
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores " + ex);
            }
        }
    }//GEN-LAST:event_btnAnteriorActionPerformed

    private void btnPosteriorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnPosteriorActionPerformed
        String info = "";
        String nom, ape, sueldo, fecha;

        if(txtDia.getText().isEmpty() || txtMes.getText().isEmpty() || txtAno.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null,"Introduce una fecha");
        }
        else
        {
            try
            {
                ResultSet r = sentencia.executeQuery("select * from trabajadores where fecha > '" + txtAno.getText() + "-" + txtMes.getText() + "-" + txtDia.getText() + "'");
                r.beforeFirst();

                while(r.next())
                {
                    nom = r.getString("nombre");
                    ape = r.getString("apellido");
                    sueldo = r.getString("sueldo");
                    fecha = r.getString("fecha");
                    fecha = fecha.substring(8, 10) + "/" + fecha.substring(5, 7) + "/" + fecha.substring(0, 4);

                    info = info + nom + " " + ape + " -- " + sueldo + " -- " + fecha + "\n";
                }

                txtArea.setText("");
                txtArea.setText(info);

            }
            catch (SQLException ex)
            {
                JOptionPane.showMessageDialog(null,"Error al consultar la tabla trabajadores " + ex);
            }
        }
    }//GEN-LAST:event_btnPosteriorActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(AccesoBD.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(AccesoBD.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(AccesoBD.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(AccesoBD.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new AccesoBD().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnAnterior;
    private javax.swing.JButton btnContienea;
    private javax.swing.JButton btnIguala;
    private javax.swing.JButton btnMayor;
    private javax.swing.JButton btnMenor;
    private javax.swing.JButton btnPosterior;
    private javax.swing.JButton btnVerTrab;
    private javax.swing.JButton btnigual;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField txtAno;
    private javax.swing.JTextArea txtArea;
    private javax.swing.JTextField txtDia;
    private javax.swing.JTextField txtMes;
    private javax.swing.JTextField txtNombre;
    private javax.swing.JTextField txtSueldo;
    // End of variables declaration//GEN-END:variables
}
