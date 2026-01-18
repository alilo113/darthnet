package commands

import (
	"github.com/spf13/cobra"
)

var (
	discovery bool
)

var rootCmd = &cobra.Command{
	Use: "Darthnet",
	Long: "Darthnet is a CLI tool for reconnaissance and information gathering. during engagements, it can be used to collect data about targets, identify vulnerabilities, and assist in penetration testing activities.",
	Run: func(cmd*cobra.Command, args []string) {
		if discovery{
			runDiscoveryScript(discovery)
			return
		}
	}
}

func init(){
	rootCmd.PersistentFlags().BoolVarP(&discovery, "discovery", "d", false, "Excute the discovery shell script")
}