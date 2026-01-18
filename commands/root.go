package commands

import (
	"github.com/spf13/cobra"
)

var (
	discovery string
)

var rootCmd = &cobra.Command{
	Use: "Darthnet",
	Long: "Darthnet is a CLI tool for reconnaissance and information gathering. during engagements, it can be used to collect data about targets, identify vulnerabilities, and assist in penetration testing activities.",
	Run: func(cmd*cobra.Command, args []string) {

	}
}

func init(){
	rootCmd.PersistentFlags().StringVarP(&discovery, "discovery", "d", "", "Excute the discovery shell script")
}