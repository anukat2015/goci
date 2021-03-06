package uk.ac.ebi.spot.goci.checker;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import uk.ac.ebi.spot.goci.tree.IRINode;
import uk.ac.ebi.spot.goci.tree.IRITree;

import javax.validation.constraints.NotNull;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Javadocs go here!
 *
 * @author Tony Burdett
 * @date 09/08/12
 */

@Service
@Component
public class IRITreeProcessor {

    @NotNull
    @Value("${watershed.cutoff}")
    private int n;

    //    private String cutoff;


    private Map<IRINode, Integer> watershedNodeCounts;

    private Logger log = LoggerFactory.getLogger(getClass());

    protected Logger getLog() {
        return log;
    }

    public IRITreeProcessor() {
        //        n = Integer.parseInt(cutoff);
        //        n = Integer.parseInt(System.getProperty("watershed.cutoff"));
        this.watershedNodeCounts = new HashMap<IRINode, Integer>();
    }

    public void processTree(IRITree tree, OutputStream out) {
        // walk tree
        int totalDeductions = recurse(tree.getRootNode());

        PrintWriter writer = new PrintWriter(out);
        writer.println("+-----------------------------------+");
        writer.println("| KnowledgeBase Ideal Legend Report |");
        writer.println("+-----------------------------------+");
        writer.println();
        writer.println("For n = " + n + ", there are " + watershedNodeCounts.keySet().size() + " watershed nodes");
        writer.println("  Key follows...");
        writer.println();
        writer.println();

        for (IRINode node : watershedNodeCounts.keySet()) {
            writer.println("[" + watershedNodeCounts.get(node) + "]\t" + node.getLabel());
        }

        writer.println("*************************************");
        writer.println();
        writer.println();
        writer.flush();
    }

    private int recurse(IRINode node) {
        // how many usages have already been rendered?
        int deductions = 0;

        // recurse to child
        for (IRINode childNode : node.getChildNodes()) {
            deductions += recurse(childNode);
        }

        // how many usages, excluding deductions?
        int newUsages = node.getUsageCount() - deductions;
        if (newUsages > n) {
            // this is renderable
            getLog().info("Node '" + node.getLabel() + "' has " + newUsages + " new usages and is a watershed");
            watershedNodeCounts.put(node, newUsages);
            return node.getUsageCount();
        }
        else {
            // this is not renderable, so don't deduct anything
            if (deductions > 0) {
                getLog().info("Node '" + node.getLabel() + "' doesn't have enough new usages (" + newUsages + ") " +
                                      "so isn't a watershed - deductions so far = " + deductions);
            }
            else {
                getLog().debug("Node '" + node.getLabel() + "': no usages, no deductions from children");
            }
            return deductions;
        }
    }
}
