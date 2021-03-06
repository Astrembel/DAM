
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
public class IMC extends javax.swing.JFrame {

    /**
     * Creates new form IMC
     */
    public IMC() {
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLEdad = new javax.swing.JLabel();
        jLPeso = new javax.swing.JLabel();
        jLEsta = new javax.swing.JLabel();
        jLResul = new javax.swing.JLabel();
        txtEstat = new javax.swing.JTextField();
        txtPeso = new javax.swing.JTextField();
        txtEdad = new javax.swing.JTextField();
        txtResul = new javax.swing.JTextField();
        btnCalcular = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel1.setText("Calcular IMC:");

        jLEdad.setText("Edad:");

        jLPeso.setText("Peso (Kg):");

        jLEsta.setText("Estatura (m):");

        jLResul.setText("Resultado:");

        txtResul.setEditable(false);

        btnCalcular.setText("Calcular");
        btnCalcular.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnCalcularActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(31, 31, 31)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(btnCalcular)
                    .addComponent(txtResul, javax.swing.GroupLayout.PREFERRED_SIZE, 330, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(txtEdad, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                .addComponent(jLPeso)
                                .addGap(18, 18, 18)
                                .addComponent(txtPeso))
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLResul)
                                .addGroup(layout.createSequentialGroup()
                                    .addComponent(jLEsta)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(txtEstat, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jLabel1)
                                .addComponent(jLEdad)))))
                .addContainerGap(39, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(22, 22, 22)
                .addComponent(jLabel1)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLEdad)
                    .addComponent(txtEdad, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLPeso)
                    .addComponent(txtPeso, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLEsta)
                    .addComponent(txtEstat, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addComponent(btnCalcular)
                .addGap(27, 27, 27)
                .addComponent(jLResul)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(txtResul, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(25, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnCalcularActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnCalcularActionPerformed
        boolean sw = true;
        
        if(txtEdad.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null, "Introduce una edad", "Error", JOptionPane.WARNING_MESSAGE);
            sw = false;
        }
        
        if(txtPeso.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null, "Introduce un peso", "Error", JOptionPane.WARNING_MESSAGE);
            sw = false;
        }
        
        if(txtEstat.getText().isEmpty())
        {
            JOptionPane.showMessageDialog(null, "Introduce una estatura", "Error", JOptionPane.WARNING_MESSAGE);
            sw = false;
        }
        
        if(sw)
        {
            try
            {
                if(Integer.parseInt(txtEdad.getText()) < 18)
                {
                    JOptionPane.showMessageDialog(null, "La edad tiene que ser mayor a 18 a??os", "Error", JOptionPane.WARNING_MESSAGE);
                    sw = false;
                }
        
                if(Integer.parseInt(txtPeso.getText()) <= 0)
                {
                    JOptionPane.showMessageDialog(null, "El peso tiene que ser mayor a 0", "Error", JOptionPane.WARNING_MESSAGE);
                    sw = false;
                }
        
                if(Double.parseDouble(txtEstat.getText()) < 1.50)
                {
                    JOptionPane.showMessageDialog(null, "la altura tiene que ser mayor a 1.50 m", "Error", JOptionPane.WARNING_MESSAGE);
                    sw = false;
                }
            }
            catch (NumberFormatException e)
            {
                JOptionPane.showMessageDialog(null, "Valor introducido no v??lido", "Error", JOptionPane.ERROR_MESSAGE);
                sw = false;
            }
            
        }
        
        
        if(sw)
        {
            double IMC;
            
            IMC = Integer.parseInt(txtPeso.getText()) / Math.pow(Double.parseDouble(txtEstat.getText()), 2);
            
            if(IMC < 20)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Riesgo de dolencias pulmonares y desnutrici??n. Anorexia nerviosa");
            }
            
            if(IMC >= 20 && IMC < 25)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Peso ideal");
            }
            
            if(IMC >= 25 && IMC < 30)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Sobrepeso o exceso de peso");
            }
            
            if(IMC >= 30 && IMC < 35)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Obesidad leve");
            }
            
            if(IMC >= 35 && IMC < 40)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Obesidad moderada");
            }
            
            if(IMC >= 40)
            {
                txtResul.setText(String.valueOf(Math.round(IMC * 100d) / 100d) + ": Obesidad m??rbida");
            }
        }
    }//GEN-LAST:event_btnCalcularActionPerformed

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
            java.util.logging.Logger.getLogger(IMC.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(IMC.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(IMC.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(IMC.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new IMC().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnCalcular;
    private javax.swing.JLabel jLEdad;
    private javax.swing.JLabel jLEsta;
    private javax.swing.JLabel jLPeso;
    private javax.swing.JLabel jLResul;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JTextField txtEdad;
    private javax.swing.JTextField txtEstat;
    private javax.swing.JTextField txtPeso;
    private javax.swing.JTextField txtResul;
    // End of variables declaration//GEN-END:variables
}
